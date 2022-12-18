#!/bin/bash

echo "ROS2 builder for the Raspberry Pi 🍓 (debian-bullseye-armv8)"

SCRIPT_DIR=`realpath $(dirname "$0")`
DISTRO=$1

mkdir -p ${SCRIPT_DIR}/ros2_ws/src

if [ -z "$DISTRO" ]; then
    DISTRO=humble
    echo "No distro specified, using $DISTRO"
    sleep 1
fi

# setup qemu (if this computer arch is x86_64)
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
fi

cd $SCRIPT_DIR
docker build -t ros2-${DISTRO}-aarch64 .
if [ $? -ne 0 ]; then
    echo "Failed to build docker image"
    exit 1
fi

docker run -it --rm --net=host \
    -v $SCRIPT_DIR/ros2_ws:/ros2_ws \
    ros2-${DISTRO}-aarch64 \
    /bin/bash -c "bash /ros2_ws/build.bash ${DISTRO}"

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
echo "--------------------------"
