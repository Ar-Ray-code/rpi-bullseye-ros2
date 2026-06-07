#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
DISTRO=${1:-lyrical}
BUILD_PROFILE=${2:-desktop}
DEBIAN_DISTRO=trixie
ROSDISTRO_INDEX_URL=
BUILD_TESTING=OFF
COLCON_BUILD_RETRIES=2
ZENOH_CARGO_BUILD_JOBS=1
LOCAL_REPOS_DIR=/rpi-bullseye-ros2/repos
FULL_REPOS="ds realsense rostackchan urg velodyne webcam"
BUILD_FULL_PKG=false

if [ "${BUILD_PROFILE}" = "full" ]; then
    BUILD_FULL_PKG=true
elif [ "${BUILD_PROFILE}" != "desktop" ]; then
    echo "Usage: bash /ros2_ws/build.bash [rosdistro] [desktop|full]"
    exit 1
fi

if [ "${DISTRO}" = "lyrical" ]; then
    ROSDISTRO_INDEX_URL="https://raw.githubusercontent.com/ros/rosdistro/lyrical/2026-05-22/index-v4.yaml"
    export ROSDISTRO_INDEX_URL
fi
PACKAGES_IGNORE="autoware_trajectory autoware_ekf_localizer autoware_map_projection_loader autoware_test_utils autoware_planning_test_manager autoware_gnss_poser autoware_route_handler autoware_map_loader autoware_simple_pure_pursuit autoware_velocity_smoother autoware_mission_planner autoware_path_generator autoware_behavior_velocity_planner_common autoware_behavior_velocity_planner autoware_motion_velocity_planner_common autoware_motion_velocity_planner autoware_motion_velocity_obstacle_stop_module autoware_behavior_velocity_stop_line_module rosbag2_examples_cpp rosbag2_examples_py realsense2_camera realsense2_rviz_plugin usb_cam velodyne_pointcloud velodyne dynamixel_hardware feetech_scs_hardware rostackchan_description rostackchan_example"

echo "=========== Build options ==========="
echo "DISTRO: ${DISTRO}"
echo "DEBIAN_DISTRO: ${DEBIAN_DISTRO}"
echo "BUILD_PROFILE: ${BUILD_PROFILE}"
echo "====================================="
echo ""

if [ -z "$DISTRO" ]; then
    DISTRO=lyrical
    echo "No distro specified, using default: ${DISTRO}"
fi

. ~/.bashrc
echo "========================================"
# lib
cmake --version

cd ${SCRIPT_DIR}
rm -rf ${SCRIPT_DIR}/src ${SCRIPT_DIR}/build ${SCRIPT_DIR}/log ${SCRIPT_DIR}/${DISTRO} ${SCRIPT_DIR}/*.repos
mkdir -p src/

if [ "${DISTRO}" = "lyrical" ]; then
    echo "Generating desktop repos from ${ROSDISTRO_INDEX_URL}"
    rosinstall_generator desktop diagnostic_updater \
        --rosdistro ${DISTRO} \
        --deps \
        --upstream-development \
        --format repos > ros2.repos
else
    wget https://raw.githubusercontent.com/ros2/ros2/${DISTRO}/ros2.repos
fi


if [ ${BUILD_FULL_PKG} = true ]; then
    echo "Building full package"
    for repo in ${FULL_REPOS}; do
        if [ -f ${LOCAL_REPOS_DIR}/${repo}.repos ]; then
            cp ${LOCAL_REPOS_DIR}/${repo}.repos .
        else
            wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/${DISTRO}/repos/${repo}.repos
        fi
    done

    for f in *.repos; do
        echo "---- importing $f ----"
        vcs import --recursive src < $f
    done
else
    echo "Building desktop package"
    vcs import --recursive src < ros2.repos
fi

rosdep update

if [ ${DISTRO} = "iron" ] || [ ${DISTRO} = "jazzy" ] || [ ${DISTRO} = "kilted" ] || [ ${DISTRO} = "lyrical" ]; then
    rm -rf src/ignition*
fi

# env : PCL, Eigen
PCL_INCLUDE_PATH=$(pkg-config --variable=includedir pcl_common 2>/dev/null)
EIGEN_INCLUDE_PATH=/usr/include/eigen3
export CPLUS_INCLUDE_PATH=${PCL_INCLUDE_PATH}:${EIGEN_INCLUDE_PATH}:$CPLUS_INCLUDE_PATH

COLCON_BUILD_ARGS=(
    --install-base "$(pwd)/${DISTRO}/"
    --packages-ignore ${PACKAGES_IGNORE}
    --merge-install
    --cmake-args
    --no-warn-unused-cli
    -DCMAKE_BUILD_TYPE=Release
    -DBUILD_TESTING=${BUILD_TESTING}
    -DBUILD_TESTING_SCIPY=OFF
    -DCMAKE_CXX_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3"
    -DCMAKE_C_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3"
)

if colcon list --names-only | grep -q '^zenoh_cpp_vendor$'; then
    echo "Prebuilding zenoh_cpp_vendor with low Rust/CMake parallelism"
    CMAKE_BUILD_PARALLEL_LEVEL=${ZENOH_CARGO_BUILD_JOBS} \
    CARGO_BUILD_JOBS=${ZENOH_CARGO_BUILD_JOBS} \
    CARGO_NET_RETRY=5 \
    MAKEFLAGS=-j${ZENOH_CARGO_BUILD_JOBS} \
        colcon build \
        --executor sequential \
        --parallel-workers 1 \
        "${COLCON_BUILD_ARGS[@]}" \
        --packages-up-to zenoh_cpp_vendor
    ZENOH_BUILD_EXIT_CODE=$?
    if [ ${ZENOH_BUILD_EXIT_CODE} -ne 0 ]; then
        exit ${ZENOH_BUILD_EXIT_CODE}
    fi
fi

BUILD_ATTEMPT=1
while true; do
    echo "Running colcon build attempt ${BUILD_ATTEMPT}/${COLCON_BUILD_RETRIES}"
    colcon build "${COLCON_BUILD_ARGS[@]}"
    BUILD_EXIT_CODE=$?
    if [ ${BUILD_EXIT_CODE} -eq 0 ]; then
        break
    fi
    if [ ${BUILD_ATTEMPT} -ge ${COLCON_BUILD_RETRIES} ]; then
        exit ${BUILD_EXIT_CODE}
    fi
    BUILD_ATTEMPT=$((BUILD_ATTEMPT + 1))
    echo "colcon build failed; retrying without cleaning the workspace"
done

echo "Cleaning build cache"
rm -rf ${SCRIPT_DIR}/src ${SCRIPT_DIR}/build ${SCRIPT_DIR}/log ${SCRIPT_DIR}/*.repos

echo "All packages built successfully"
unset COLCON_OPTION
exit 0
