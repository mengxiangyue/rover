echo "add this file into your project/workspace folder"
echo "framework will be add into Products folder"
echo "sh gen.sh [workspace] [target] [project_dir]"
if [ $# -eq 3 ];then
    echo "参数错误"
    exit 1
fi

WORKSPACE=$1
FMK_NAME=$2
SRCROOT=$(dirname $0)
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
echo ${WORKSPACE}
# Working dir will be deleted after the framework creation.
WRK_DIR=${SRCROOT}/build
DEVICE_DIR=${WRK_DIR}/iphoneos/Build/Intermediates.noindex/ArchiveIntermediates/${FMK_NAME}/IntermediateBuildFilesPath/UninstalledProducts/iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/iphonesimulator/Build/Products/Release-iphonesimulator/${FMK_NAME}.framework
xcodebuild -workspace ${WORKSPACE}.xcworkspace -scheme ${FMK_NAME} -configuration Release -sdk iphoneos -derivedDataPath 'build/iphoneos' clean archive
if [ $? -ne 0 ];then
	echo ${FMK_NAME} iphoneos framework build error
	exit 2
fi 
xcodebuild -workspace ${WORKSPACE}.xcworkspace -scheme ${FMK_NAME} -configuration Release -sdk iphonesimulator clean build -derivedDataPath 'build/iphonesimulator'
if [ $? -ne 0 ];then
	echo ${FMK_NAME} iphonesimulator framework build error
	exit 2
fi 
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

cp -R "${SIMULATOR_DIR}/Modules/${FMK_NAME}.swiftmodule/" "${INSTALL_DIR}/Modules/${FMK_NAME}.swiftmodule/"
# Uses the Lipo Tool to merge both binaryfiles (x86_64 + armv64) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
if [ $? -ne 0 ];then
	echo create universal ${FMK_NAME} framework error
	exit 2
fi 
rm -r "${WRK_DIR}"
open "${INSTALL_DIR}"
exit 0
