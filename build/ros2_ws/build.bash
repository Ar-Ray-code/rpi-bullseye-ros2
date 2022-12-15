#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
DISTRO=$1

if [ -z "$DISTRO" ]; then
    DISTRO=humble
    echo "No distro specified, using default: ${DISTRO}"
fi

rm -rf ${SCRIPT_DIR}/ros2.repos
wget https://raw.githubusercontent.com/ros2/ros2/${DISTRO}/ros2.repos
vcs import src < ros2.repos

rosdep update
# rosdep install -r -y -i --from-paths /ros2_ws/src/ --rosdistro ${DISTRO}

colcon build --install-base $(pwd)/${DISTRO}/ --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3" -DCMAKE_C_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3"

if [ $? -ne 0 ]; then
    exit 1
fi

echo "All packages built successfully"
unset COLCON_OPTION
exit 0
