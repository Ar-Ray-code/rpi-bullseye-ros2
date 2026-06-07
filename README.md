# Raspberry Pi OS ROS2

Build ROS2 for Raspbian


## Books📚

- 🆕 [RaspberryPi OSではじめるROS 2 ② (Zenn)](https://zenn.dev/array/books/raspi_os_de_hajimeru_ros2_2)
- [RaspberryPi OSではじめるROS2 (Zenn)](https://zenn.dev/array/books/5efdb438cf8be3)

<br>

![](./images_for_readme//rviz_rpi.jpg)


<br>

## Support

For instructions on installing previous versions, please check the respective branch.

### Latest : v0.3.3

[v0.3.3](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/v0.3.3)

| Distro | Debian | arm64-desktop |
| --- | --- | --- |
| lyrical | trixie | [URL](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/v0.3.3/ros-lyrical-desktop-0.3.3_20260607_arm64.deb) |

### Install (trixie)

- OS   : Raspberry Pi OS / Debian trixie arm64
- ROS2 : ROS2 lyrical

```bash
wget https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/v0.3.3/ros-lyrical-desktop-0.3.3_20260607_arm64.deb
sudo apt install ./ros-lyrical-desktop-0.3.3_20260607_arm64.deb

sudo pip install --break-system-packages vcstool #A tool that can be used when you want to reference a repository from a .repos file.
```

## Uninstall

```bash
sudo apt remove ros-lyrical-desktop
```

<br>

### Load ROS2

```bash
source /opt/ros/lyrical/setup.bash
```

<br>

## Build ROS2

- [README](./build/README.md)

<br>

## Cases

If rpi-bullseye-ros2 has made your project work, please let me know!✨

| | URL |
| --- | --- |
| ROS-With-Arducam-ToF-Camera (arducam) | [URL](https://docs.arducam.com/Raspberry-Pi-Camera/Tof-camera/ROS-With-Arducam-ToF-Camera)
| CoRE2024 AutoRobot team firmware | [scramble-robot/CoRE_AutoRobot_2024_raspberrypi](https://github.com/scramble-robot/CoRE_AutoRobot_2024_raspberrypi) |
| RPi5 + Hailo-8 application exampoles | [kyrikakis/hailo_tappas_ros2](https://github.com/kyrikakis/hailo_tappas_ros2) |

<br>

## About author

- author : [Ar-Ray](https://github.com/Ar-Ray-code)
- [X (Twitter)](https://twitter.com/Ray255Ar)

<br>

## Support me!

このプロジェクトは学生向けの軽量なROS2環境を提供するためにあります。
あなたがもしこのプロジェクトに助けられた場合、その助けを継続する支援をお願いします。

This project is to provide a lightweight ROS2 envjazzyment for students.
If you have been helped by this project, please help us continue that help.

[sponsors/Ar-Ray-code](https://github.com/sponsors/Ar-Ray-code?preview=true)
