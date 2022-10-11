#!/bin/bash

# Read argment
# e.g
# 1. $ bash install humble
# 2. $ bash install humble aarch64
# 3. $ bash install humble aarch64 0.2.0
# 4. $ bash install humble aarch64 0.2.0 /opt/ros

SCRIPT_DIR=$(cd $(dirname $0); pwd)
TARGET_DISTRO=$1
ARCH=$2
VERSION=$3
ROS_INSTALL_DIR=$4
DL_ONLY=$5

if [ -z "$TARGET_DISTRO" ];     then TARGET_DISTRO="humble";      fi
if [ -z "$ARCH" ];              then ARCH="aarch64";                 fi
if [ -z "$VERSION" ];           then VERSION="0.2.0";               fi
if [ -z "$ROS_INSTALL_DIR" ];   then ROS_INSTALL_DIR="/opt/ros";    fi

TARGET_ZIP="$TARGET_DISTRO-$ARCH"

echo "============================================"
echo " Ar-Ray-code/rpi-bullseye-ros2              "
echo "============================================"
echo " "
echo "Download ROS2 (Distro-Arch): $TARGET_ZIP"
echo "Download version: $VERSION"
echo "ROS_INSTALL_DIR: $ROS_INSTALL_DIR"
echo " "
echo "============================================"

TARGET_ZIP=$TARGET_ZIP.zip

if [ ! -f $ROS_INSTALL_DIR/$TARGET_DISTRO/setup.bash ]; then
    echo "============================================"
    echo "already downloaded, skip download."
    echo "============================================"
    exit 0

# Download zip ===========================================================================
sudo apt update
sudo apt install git wget zip -y
if [ ! -f $SCRIPT_DIR/$TARGET_ZIP ]; then
    echo "============================================"
    echo "download: $TARGET_ZIP ..."

    URL="https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/ros2-$VERSION/$TARGET_ZIP"
    wget $URL || { echo "Check the github release and see if the file is there." && unset TARGET_ZIP ROS_INSTALL_DIR VERSION TARGET_DISTRO SCRIPT_DIR && exit 1; }

    # extract from zip and copy to $ROS_INSTALL_DIR
    sudo mkdir -p $ROS_INSTALL_DIR
    sudo unzip $TARGET_ZIP -d $ROS_INSTALL_DIR
fi

# Install dependencies ===================================================================
cd $SCRIPT_DIR
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2.git

# DL_ONLY selected -> exit
if [ ! -z "$DL_ONLY" ]; then
    echo "Skip install recommended dependencies. ($DL_ONLY)"
    exit 0
fi

rm $TARGET_ZIP
unset TARGET_ZIP ROS_INSTALL_DIR VERSION TARGET_DISTRO

sudo bash $SCRIPT_DIR/rpi-bullseye-ros2/install-list/apt.bash $SCRIPT_DIR/rpi-bullseye-ros2/install-list/apt-list.txt
pip3 install -r $SCRIPT_DIR/rpi-bullseye-ros2/install-list/requirements.txt
sudo pip3 install vcstool colcon-common-extensions
# Delete downloaded repository and unset env
rm -rf $SCRIPT_DIR/rpi-bullseye-ros2
unset SCRIPT_DIR
