SCRIPT_DIR=$(cd $(dirname $0); pwd)
TARGET_DISTRO=$1
ARCH=$2 
ROS_INSTALL_DIR=$3
DL_ONLY=$4

VERSION=$(cat ${SCRIPT_DIR}/config/version.txt)

if [ -z "$TARGET_DISTRO" ];     then TARGET_DISTRO="humble";      fi
if [ -z "$ARCH" ];              then ARCH="arm64";                 fi
if [ -z "$VERSION" ];           then VERSION="0.2.0";               fi
if [ -z "$ROS_INSTALL_DIR" ];   then ROS_INSTALL_DIR="/opt/ros";    fi

echo "============================================"
echo " Ar-Ray-code/rpi-bullseye-ros2              "
echo ""
echo "TARGET_DISTRO: ${TARGET_DISTRO}"
echo "ARCH: ${ARCH}"
echo "VERSION: ${VERSION}"
echo "Build Date: $(date +%Y%m%d)"
echo "ROS_INSTALL_DIR: ${ROS_INSTALL_DIR}"
echo "============================================"
echo ""

# name-variables -------------------------------------------------------------------------------
DATE=$(date +%Y%m%d)
DEB_NAME="ros-$TARGET_DISTRO-desktop-${VERSION}_${DATE}_${ARCH}"
# path-variables -------------------------------------------------------------------------------
TARGET_DIR=${SCRIPT_DIR}/ros2_ws/${TARGET_DISTRO}
DEB_ROOT=${SCRIPT_DIR}/deb/${DEB_NAME}
INSTALL_DIR=${DEB_ROOT}/opt/ros/${TARGET_DISTRO}

# copy files to deb folder ---------------------------------------------------------------
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}
cp -r ${TARGET_DIR}/* ${INSTALL_DIR}/

# create control file ---------------------------------------------------------------------
rm -rf ${DEB_ROOT}/DEBIAN
mkdir -p ${DEB_ROOT}/DEBIAN

DEPENDS=$(cat ${SCRIPT_DIR}/config/depends.txt | tr '\n' ',' | sed 's/,$//')
echo "depens: $DEPENDS"
CONTROL_FILE=${DEB_ROOT}/DEBIAN/control
echo "Package: ros-$TARGET_DISTRO-desktop" > ${CONTROL_FILE}
echo "Version: ${VERSION}" >> ${CONTROL_FILE}
echo "Section: base" >> ${CONTROL_FILE}
echo "Priority: optional" >> ${CONTROL_FILE}
echo "Architecture: ${ARCH}" >> ${CONTROL_FILE}
echo "Depends: $DEPENDS" >> ${CONTROL_FILE}
echo "Maintainer: Ar-Ray-code <ray255ar@gmail.com>" >> ${CONTROL_FILE}
echo "Description: ROS2 $TARGET_DISTRO for Raspberry Pi OS Bullseye 64bit" >> ${CONTROL_FILE}

dpkg-deb --build --root-owner-group ${DEB_ROOT} ${SCRIPT_DIR}/deb/${DEB_NAME}.deb

# ----------------------------------------------------------------------------------------
