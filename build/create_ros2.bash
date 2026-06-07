#!/bin/bash

SCRIPT_DIR=`realpath $(dirname "$0")`
DISTRO=${1:-"lyrical"}
BUILD_PROFILE=${2:-"desktop"}
DEBIAN_DISTRO="trixie"

if [ "${BUILD_PROFILE}" != "desktop" ] && [ "${BUILD_PROFILE}" != "full" ]; then
    echo "Usage: bash build/create_ros2.bash [rosdistro] [desktop|full]"
    exit 1
fi

echo "ROS2-${DISTRO} builder for the Raspberry Pi 🍓 (debian-${DEBIAN_DISTRO}-armv8)"

rm -rf ${SCRIPT_DIR}/ros2_ws/*.repos
mkdir -p ${SCRIPT_DIR}/ros2_ws/src

echo "Distro: ${DISTRO}"
echo "Debian distro: ${DEBIAN_DISTRO}"
echo "Build profile: ${BUILD_PROFILE}"
sleep 1

# setup qemu (if this computer arch is x86_64)
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
fi

cd $SCRIPT_DIR
docker build \
    --build-arg "DEBIAN_DISTRO=${DEBIAN_DISTRO}" \
    -t ros2-${DISTRO}-aarch64 .
if [ $? -ne 0 ]; then
    echo "Failed to build docker image"
    exit 1
fi

LOCAL_REPOS_DIR=`realpath ${SCRIPT_DIR}/../repos`
START_TIME=`date +%s`
DOCKER_TTY_ARGS=()
if [ -t 0 ]; then
    DOCKER_TTY_ARGS=(-it)
fi

docker run "${DOCKER_TTY_ARGS[@]}" --rm --net=host \
    -v $SCRIPT_DIR/ros2_ws:/ros2_ws \
    -v ${LOCAL_REPOS_DIR}:/rpi-bullseye-ros2/repos:ro \
    ros2-${DISTRO}-aarch64 \
    /bin/bash -c "bash /ros2_ws/build.bash ${DISTRO} ${BUILD_PROFILE}"
BUILD_EXIT_CODE=$?
STOP_TIME=`date +%s`

if [ ${BUILD_EXIT_CODE} -ne 0 ]; then
    echo "Failed to build ROS2"
    exit ${BUILD_EXIT_CODE}
fi

cd $SCRIPT_DIR/ros2_ws

# zip -r ${SCRIPT_DIR}/${DISTRO}-aarch64.zip ${DISTRO}
# if [ $? -ne 0 ]; then
#     echo "Failed to zip."
#     exit 1
# fi
cd ${SCRIPT_DIR}

echo ""
echo "All done!"
echo "--------------------------"
echo "zip : -"
echo "distro : ${DISTRO}"
echo "Elapsed time: $((STOP_TIME - START_TIME)) seconds"
echo "--------------------------"
