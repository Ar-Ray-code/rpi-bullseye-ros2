#!/bin/bash

# Setting up the environments
SCRIPT_DIR=$(cd $(dirname $0); pwd)
_USER=${SCRIPT_DIR##*home/}
USER=${_USER%%/*}

ROS_INSTALL_DIR="/home/$USER/galactic"
TARGET_ZIP="galactic-armv7l"

# ==============================================================================
sudo bash $SCRIPT_DIR/install-list/apt.bash $SCRIPT_DIR/install-list/apt-list.txt
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