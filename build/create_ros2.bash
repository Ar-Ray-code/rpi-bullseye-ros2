#!/bin/bash

SCRIPT_DIR=`realpath $(dirname "$0")`
DISTRO=${1:-"iron"}
DEBIAN_DISTRO=${2:-"bullseye"}
BUILD_FULL_PKG=${3:-false}
# if build_full_pkg = full, build all packages
if [ ${BUILD_FULL_PKG} = full ]; then
    BUILD_FULL_PKG=true
fi

echo "ROS2-${DISTRO} builder for the Raspberry Pi 🍓 (debian-${DEBIAN_DISTRO}-armv8)"

sudo rm -rf ${SCRIPT_DIR}/ros2_ws/*.repos
mkdir -p ${SCRIPT_DIR}/ros2_ws/src

echo "Distro: ${DISTRO}"
echo "Debian distro: ${DEBIAN_DISTRO}"
echo "Build full package: ${BUILD_FULL_PKG}"
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

docker run -it --rm --net=host \
    -v $SCRIPT_DIR/ros2_ws:/ros2_ws \
    ros2-${DISTRO}-aarch64 \
    /bin/bash -c "bash /ros2_ws/build.bash ${DISTRO} ${BUILD_FULL_PKG}"

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
