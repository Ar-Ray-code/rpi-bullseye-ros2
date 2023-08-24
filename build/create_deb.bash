SCRIPT_DIR=$(cd $(dirname $0); pwd)

TARGET_DISTRO=${1-"iron"}
ARCH=${2-"arm64"}
ROS_INSTALL_DIR=${3-"/opt/ros"}
VERSION=$(cat ${SCRIPT_DIR}/config/version.txt)


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

DEPENDS=$(cat ${SCRIPT_DIR}/config/depends.txt ${SCRIPT_DIR}/config/full.txt | tr '\n' ',' | sed 's/,$//')
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

dpkg-deb --build -Z xz --root-owner-group ${DEB_ROOT} ${SCRIPT_DIR}/deb/${DEB_NAME}.deb

# ----------------------------------------------------------------------------------------
