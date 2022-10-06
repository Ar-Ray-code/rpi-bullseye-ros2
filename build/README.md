# Building ROS2 base pkg using Jetson

## Requirements

- Jetson AGX Xavier or Orin (aarch64)
- Docker (aarch64)

<br>

## ❌ Excluded packages ❌

- RViz
- rosbag
- rqt

<br>

## build ROS2-base

```bash
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2.git
cd rpi-bullseye-ros2/build

bash create_ros.bash humble
```
After all builds are successful

```bash
ls
# > humble-aarch64.zip
```

<br>

## Install ROS2 to Raspbian-Bullseye (aarch64)

```bash
# Raspbian-Bullseye
sudo mkdir /opt/ros -p
sudo unzip humble-aarch64.zip -d /opt/ros
```