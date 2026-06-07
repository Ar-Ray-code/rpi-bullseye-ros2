# Building ROS2 desktop pkg using Docker

## Requirements
- Docker (ARM64)
- 12.0GB RAM Resource (Please check Docker.desktop/Settings/Resources)

<br>

## Install Docker (Ubuntu, build-base)

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

## build ROS2 desktop

```bash
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2.git
cd rpi-bullseye-ros2/build

bash create_ros2.bash lyrical
```

To build the rpi-bullseye-ros2 full package set:

```bash
bash create_ros2.bash lyrical full
```

<br>

## Create Debian package

```bash
bash create_deb.bash lyrical arm64 /opt/ros
```
