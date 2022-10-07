# rpi-bullseye-ROS2

Build ROS2-Humble for Raspbian-bullseye

Scripts for build ROS2 to running on Raspbian.

> Note: Compiled for Raspbian-bullseye (32bit)

<br>

## Support

### Latest : ros2-0.2.0

- [ros2-0.2.0](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/ros2-0.2.0)

| Version | aarch64| Download |
| --- | --- | --- |
| humble | ✔ | URL |
| galactic | | |

<br>

<details><summary>ros2-0.1.0</summary>

- [ros2-0.1.0](https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/tag/ros2-0.1.0)

| Version | aarch64 | arm7l |
| --- | --- | --- |
| humble | ✔ | ✔ |
| galactic | | ✔ |

</details>

<br>

### ❌ Excluded packages ❌

- RViz
- rosbag
- rqt

<br>

## Install

On Raspberry Pi Bullseye, run only following command.

```bash
# default : (humble, arm7l)
curl -s https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/install.bash | bash
```

or

```bash
# default : (humble, aarch64)
wget https://raw.githubusercontent.com/Ar-Ray-code/rpi-bullseye-ros2/main/install.bash
bash install galactic aarch64 0.1.0 /opt/ros
```

Load ROS2

```bash
source /opt/ros/humble/setup.bash
```

<br>

## Build

[README](./build/README.md)

<br>

## About author

- author : [Ar-Ray](https://github.com/Ar-Ray-code)
- [Twitter](https://twitter.com/Ray255Ar)
