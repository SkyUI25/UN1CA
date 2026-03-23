# Copyright (c) 2025 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later
# ROM VERSION
DEVICE_MODEL=$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/ROM/system/system/build.prop" "ro.product.system.model")

case "$DEVICE_MODEL" in
    SM-S*)
        VERSION_ROM="Azure"
        ;;
    SM-A*|SM-M*)
        VERSION_ROM="Cirrus"
        ;;
    *)
        VERSION_ROM="null"
        ;;
esac

# MAJOR VERSION
SDK_VERSION=$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/ROM/system/system/build.prop" "ro.system.build.version.sdk")

case "$SDK_VERSION" in
    35)
        MAJOR_VERSION="7"
        ;;
    36)
        MAJOR_VERSION="8"
        ;;
    *)
        MAJOR_VERSION="null"
        ;;
esac

# Only the below variable(s) need to be changed!
BUILD_VERSION="Stable"
ROM_NAME="SkyUI"
ROM_VERSION=$VERSION_ROM
VERSION_MAJOR=$MAJOR_VERSION
VERSION_MINOR=00
VERSION_PATCH=01

# The below variables will be generated automatically
#
# Version name
SKYUI_VERSION="${ROM_NAME}-${ROM_VERSION}.${VERSION_MAJOR}.${VERSION_PATCH}"
MAJOR_PATCH="${VERSION_MAJOR}0${VERSION_MINOR}${VERSION_PATCH}"# Append "+" to version name if commits have been added since the last tag

# Append "+" to version name if commits have been added since the last tag
LATEST_TAG="$(git describe --tags --abbrev=0 2> /dev/null)"
if [ "$LATEST_TAG" ]; then
    if [[ "$(git rev-list --count "$LATEST_TAG...HEAD" 2> /dev/null)" =~ 0*[1-9][0-9]* ]]; then
        SKYUI_VERSION+="+"
    fi
fi
# Append current commit hash to version name
ROM_VERSION+="-$(git rev-parse --short HEAD 2> /dev/null || echo "null")"
# Append "-dirty" to version name if uncommited changes are detected
if [ "$(git --no-optional-locks status -uno --porcelain 2> /dev/null)" ]; then
    SKYUI_VERSION+="-dirty"
fi
