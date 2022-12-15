# rpi-bullseye-ROS2

Build ROS2-Humble for Raspbian-bullseye

Scripts for build ROS2 to running on Raspbian (64bit).

![](./images_for_readme//rviz_rpi.jpg)

<br>

## Support

### Latest : ros2-0.2.0

[ros2-0.3.0](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/ros2-0.3.0)

| Distro | arm64 |
| --- | --- |
| humble | ✔ |
| galactic | |
| foxy | |

### Install

- OS   : RaspberryPi OS bullseye arm64
- ROS2 : ROS2 Humble

```bash
wget https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/ros2-0.3.0/ros-humble-desktop-0.3.0_20221215_arm64.deb
sudo apt install ./ros2-humble-desktop-0.3.0_20221215_arm64.deb
```

### Uninstall

```bash
sudo apt remove ros-${DISTRO}-desktop
# sudo apt remove ros-humble-desktop
```

### `DEBIAN/control` file

```conf
Package: ros-humble-desktop
Version: 0.3.0
Section: base
Priority: optional
Architecture: arm64
Depends: bison,build-essential,curl,cmake,doxygen,git,gnupg,libacl1-dev,libasio-dev,libbullet-dev,libeigen3-dev,libfreetype-dev,liblog4cxx-dev,libopencv-dev,libresource-retriever-dev,libsdl2-dev,libtinyxml2-dev,libxaw7-dev,libxcursor-dev,libxrandr-dev,lsb-release,mingw-w64-i686-dev,pciutils,pyqt5-dev,python3-flake8,python3-lark,python3-netifaces,python3-numpy,python3-pip,python3-pydot,python3-pyqt5,python3-pyqt5.qtsvg,python3-pytest-cov,python3-rosdep2,python3-setuptools,python3-sip,qtbase5-dev,sip-dev,xterm,wget,zip
Maintainer: Ar-Ray-code <ray255ar@gmail.com>
Description: ROS2 humble for Raspberry Pi OS Bullseye 64bit
```

<br>

### Load ROS2

```bash
source /opt/ros/${DISTRO}/setup.bash
# source /opt/ros/humble/setup.bash
```

<br>

<details><summary>ros2-0.2.0</summary>

[ros2-0.2.0](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/ros2-0.2.0)

| Distro | aarch64 |
| --- | --- |
| humble | ✔ |
| galactic | |

### Install

- OS   : RaspberryPi OS bullseye aarch64
- ROS2 : ROS2 Humble

```bash
# (humble, aarch64)
curl -O https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/install.bash
# bash install.bash <distro> <arch> <version> <install-dir>
bash install.bash humble aarch64 0.2.0 /opt/ros
```

<br>

</details>

<details><summary>ros2-0.1.0</summary>

<br>

[ros2-0.1.0](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/ros2-0.1.0)


### ❌ Excluded packages ❌

- RViz
- rosbag
- rqt

<br>

| Distro | aarch64 | arm7l |
| --- | --- | --- |
| humble | ✔ | ✔ |
| galactic | | ✔ |

### Install

- OS   : RaspberryPi OS bullseye aarch64
- ROS2 : ROS2 Humble

```bash
# (humble, aarch64)
wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/install.bash
bash install.bash humble aarch64 0.1.0 /opt/ros

# galactic, arm7l
# bash install.bash galactic arm7l 0.1.0 /opt/ros
```

### Load ROS2

```bash
source /opt/ros/humble/setup.bash
```

<br>

</details>

<br>


## Build ROS2

- [README](./build/README.md)

<br>

## Cross compile 🛠️

- [Ar-Ray-code/rpi-bullseye-ros2-xcompile](https://github.com/Ar-Ray-code/rpi-bullseye-ros2-xcompile)

<br>

## About author

- author : [Ar-Ray](https://github.com/Ar-Ray-code)
- [Twitter](https://twitter.com/Ray255Ar)
