
# workaround for bitcode generation problem with Xcode 7.3
# unset TOOLCHAINS
# Sets the target folders and the final framework product.
# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
# 例如: FMK_NAME = "MyFramework"
#FMK_NAME=${PROJECT_NAME}
SRCROOT=$(dirname $0)
FMK_NAME="UserService"
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
# Working dir will be deleted after the framework creation.
WRK_DIR=${SRCROOT}/build
DEVICE_DIR=${WRK_DIR}/iphoneos/Build/Intermediates.noindex/ArchiveIntermediates/${FMK_NAME}/IntermediateBuildFilesPath/UninstalledProducts/iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/iphonesimulator/Build/Products/Release-iphonesimulator/${FMK_NAME}.framework
xcodebuild -workspace '../TestFramework.xcworkspace' -scheme "${FMK_NAME}" -configuration Release -sdk iphoneos -derivedDataPath 'build/iphoneos' clean archive
xcodebuild -workspace '../TestFramework.xcworkspace' -scheme "${FMK_NAME}" -configuration Release -sdk iphonesimulator clean build -derivedDataPath 'build/iphonesimulator'
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
# ARCHIVE_DIR="${SRCROOT}/Products/archive/${FMK_NAME}.framework"
# mkdir -p "${ARCHIVE_DIR}"
# cp -R "${DEVICE_DIR}/" "${ARCHIVE_DIR}"
cp -R "${SIMULATOR_DIR}/Modules/${FMK_NAME}.swiftmodule/" "${INSTALL_DIR}/Modules/${FMK_NAME}.swiftmodule/"
# Uses the Lipo Tool to merge both binaryfiles (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
#rm -r "${WRK_DIR}"
open "${INSTALL_DIR}"
