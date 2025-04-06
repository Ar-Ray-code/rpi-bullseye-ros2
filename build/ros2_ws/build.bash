#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
DISTRO=${1:-humble}
BUILD_FULL_PKG=${2:-false}

echo "=========== Build options ==========="
echo "DISTRO: ${DISTRO}"
echo "BUILD_FULL_PKG: ${BUILD_FULL_PKG}"
echo "====================================="
echo ""

if [ -z "$DISTRO" ]; then
    DISTRO=humble
    echo "No distro specified, using default: ${DISTRO}"
fi

. ~/.bashrc
echo "========================================"
# lib
cmake --version

cd ${SCRIPT_DIR}
rm -rf ${SCRIPT_DIR}/ros2.repos
wget https://raw.githubusercontent.com/ros2/ros2/${DISTRO}/ros2.repos
mkdir -p src/


if [ ${BUILD_FULL_PKG} = true ]; then
    echo "Building full package"
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/ds.repos
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/realsense.repos
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/rostackchan.repos
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/urg.repos
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/velodyne.repos
    wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/repos/webcam.repos

    for f in *.repos; do
        echo "---- importing $f ----"
        vcs import --recursive src < $f
    done
else
    echo "Building minimal package"
    vcs import --recursive src < ros2.repos
fi

rosdep update
# rosdep install -r -y -i --from-paths /ros2_ws/src/ --rosdistro ${DISTRO}

if [ ${DISTRO} = "iron" ] || [ ${DISTRO} = "jazzy" ]; then
    rm -rf src/ignition*
fi

# env : PCL, Eigen
PCL_INCLUDE_PATH=$(pkg-config --variable=includedir pcl_common 2>/dev/null)
EIGEN_INCLUDE_PATH=/usr/include/eigen3
export CPLUS_INCLUDE_PATH=${PCL_INCLUDE_PATH}:${EIGEN_INCLUDE_PATH}:$CPLUS_INCLUDE_PATH

colcon build \
    --install-base $(pwd)/${DISTRO}/ \
    --packages-ignore autoware_trajectory autoware_ekf_localizer autoware_map_projection_loader autoware_test_utils autoware_planning_test_manager autoware_gnss_poser autoware_route_handler autoware_map_loader autoware_simple_pure_pursuit autoware_velocity_smoother autoware_mission_planner autoware_path_generator autoware_behavior_velocity_planner_common autoware_behavior_velocity_planner autoware_motion_velocity_planner_common autoware_motion_velocity_planner autoware_motion_velocity_obstacle_stop_module autoware_behavior_velocity_stop_line_module \
    --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3" -DCMAKE_C_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3"

if [ $? -ne 0 ]; then
    exit 1
fi

echo "All packages built successfully"
unset COLCON_OPTION
exit 0
