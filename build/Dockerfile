FROM arm64v8/debian:bullseye

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt install locales -y && \
    locale-gen en_US en_US.UTF-8 && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8

RUN apt-get update && \
	apt-get install -y \
	pciutils \
	xterm \
	libacl1-dev \
	libtinyxml2-dev \
	bison \
	libasio-dev \
	libeigen3-dev \
	libxrandr-dev \
	libxcursor-dev \
	libsdl2-dev \
	mingw-w64-i686-dev \
	doxygen \
	liblog4cxx-dev \
	python3-lark \
	build-essential \
	cmake \
	git \
	python3-flake8 \
	python3-pip \
	python3-pytest-cov \
	python3-rosdep \
	python3-setuptools \
	wget \
	curl \
	gnupg \
	lsb-release \
	qtbase5-dev \
	python3-sip \
	libopencv-dev \
	pyqt5-dev \
	libbullet-dev \
	sip-dev \
	libxaw7-dev \
	python3-pyqt5 \
	python3-numpy \
	python3-pydot \
	python3-pyqt5.qtsvg \
	python3-netifaces \
	libfreetype-dev \
	libresource-retriever-dev && \
	rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install \
	flake8-blind-except \
	flake8-builtins \
	flake8-class-newline \
	flake8-comprehensions \
	flake8-deprecated \
	flake8-docstrings \
	flake8-import-order \
	flake8-quotes \
	pytest-repeat \
	pytest-rerunfailures \
	pytest \
	setuptools \
	importlib-metadata \
	importlib-resources \
	lark-parser

RUN pip install vcstool colcon-common-extensions

RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws
