#!/bin/bash

DISTRO=$1

if [ -z "$DISTRO" ]; then
    DISTRO=humble
    echo "No distro specified, using default: ${DISTRO}"
fi

wget https://raw.githubusercontent.com/ros2/ros2/${DISTRO}/ros2.repos
vcs import src < ros2.repos

rosdep update
rosdep install -r -y -i --from-paths /ros2_ws/src/ --rosdistro ${DISTRO}

colcon build --install-base $(pwd)/${DISTRO}/

if [ $? -ne 0 ]; then
    exit 1
fi

echo "All packages built successfully"
unset COLCON_OPTION
exit 0
