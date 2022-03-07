#!/bin/bash

# Setting up the environments
SCRIPT_DIR=$(cd $(dirname $0); pwd)
_USER=${SCRIPT_DIR##*home/}
USER=${_USER%%/*}

TARGET_ZIP="galactic-armv7l"

ROS_INSTALL_DIR=$1
if [ -z "$ROS_INSTALL_DIR" ]; then
    ROS_INSTALL_DIR="/home/$USER/galactic"
fi

echo "ROS_INSTALL_DIR: $ROS_INSTALL_DIR"

# ==============================================================================
sudo apt install git
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2.git

sudo bash $SCRIPT_DIR/rpi-bullseye-ros2/install-list/apt.bash $SCRIPT_DIR/rpi-bullseye-ros2/install-list/apt-list.txt
pip3 install -r $SCRIPT_DIR/install-list/requirements.txt

wget https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/galactic-0.1.0/$TARGET_ZIP.zip
unzip $TARGET_ZIP.zip -d /home/$USER/
rm $TARGET_ZIP.zip

# sudo pip install
sudo pip install vcstool colcon-common-extensions

# Unset Environment
unset SCRIPT_DIR
unset _USER
unset USER

unset ROS_INSTALL_DIR
unset TARGET_ZIP