# Building ROS2 base pkg using Jetson

## Requirements

- Jetson AGX Xavier or Orin (aarch64) or AWS Ubuntu-arm64
- Docker (aarch64)

<br>

## Install Docker

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

<br>

## build ROS2-base

```bash
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2.git
cd rpi-bullseye-ros2/build

bash create_ros2.bash humble
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
