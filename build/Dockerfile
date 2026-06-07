ARG DEBIAN_DISTRO=trixie
FROM arm64v8/debian:${DEBIAN_DISTRO}

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV RUST_TOOLCHAIN=1.93.0
ENV PATH=/root/.cargo/bin:${PATH}

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
	ca-certificates \
	git \
	libgmock-dev \
	libgtest-dev \
	libncurses-dev \
	liborocos-kdl-dev \
	python3-flake8 \
	python3-pip \
	python3-pytest-cov \
	python3-argcomplete \
	python3-osrf-pycommon \
	python3-psutil \
	python3-rosdep2 \
	python3-rosinstall-generator \
	python3-setuptools \
	python3-yaml \
	wget \
	curl \
	gnupg \
	lsb-release \
	qtbase5-dev \
	libopencv-dev \
	pyqt5-dev \
	libbullet-dev \
	libyaml-dev \
	libxaw7-dev \
	python3-pyqt5 \
	python3-pyqt5.sip \
	python3-numpy \
	pybind11-dev \
	python3-pykdl \
	python3-pydot \
	python3-pyqt5.qtsvg \
	python3-netifaces \
	python3-empy \
	python3-sipbuild \
	python3-pyqtbuild \
	sip-tools \
	shiboken6 \
	libfreetype-dev \
	libresource-retriever-dev \
	python3-jinja2 \
	# iron
	liblttng-ust-dev \
	# jazzy
	liblttng-ctl-dev \
	# lyrical/trixie
	libiceoryx-posh2 \
	nlohmann-json3-dev \
	# YOLOX
	libboost-python-dev \
	# Realsense
	libssl-dev \
	libusb-1.0-0-dev \
	pkg-config \
	libgtk-3-dev \
	libglfw3-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	# Velodyne
	libpcl-dev \
	libyaml-cpp-dev \
	libpcap-dev \
	# joy
	libspnav-dev \
	libbluetooth-dev \
	libcwiid-dev \
	# generate_parameter_library
	python3-typeguard \
	# ros2_control
	libfmt-dev \
	librange-v3-dev \
	libcap-dev \
	# stackchan
	libserial-dev \
	libexpected-dev \
	libassimp-dev \
	liboctomap-dev \
	# autoware-core
	libsimde-dev \
	libmatio-dev \
	libmrtd-dev \
	libpugixml-dev \
	libgeographiclib-dev && \
	rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
	sh -s -- -y --profile minimal --default-toolchain ${RUST_TOOLCHAIN} && \
	rustc --version && \
	cargo --version

# RUN pip install --upgrade pip

RUN pip install --break-system-packages \
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
	lark-parser \
	cython

RUN pip install --break-system-packages vcstool colcon-common-extensions

RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws
