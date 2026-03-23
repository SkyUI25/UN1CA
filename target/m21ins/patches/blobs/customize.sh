DEVICE_MODEL=$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/ROM/system/system/build.prop" "ro.product.system.model")

# Tentukan ROM_VERSION
case "$DEVICE_MODEL" in
    SM-S*)
		ROM_VERSION="Azure"
        ;;
    SM-A*|SM-M*)
		ROM_VERSION="Cirrus"
        ;;
    *)
        ROM_VERSION="null"
        ;;
esac

LOG_STEP_IN "- Adding stock SoundBooster libs"
find "$WORK_DIR/system/system/lib" -name 'lib_SoundBooster_*.so' -type f | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/lib/$(basename "$f")"
done
find "$WORK_DIR/system/system/lib64" -name 'lib_SoundBooster_*.so' -type f | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/lib64/$(basename "$f")"
done
find "$WORK_DIR/system/system/lib" -name 'lib_SAG_EQ_ver*.so' -type f | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/lib/$(basename "$f")"
done
find "$WORK_DIR/system/system/lib64" -name 'lib_SAG_EQ_ver*.so' -type f | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/lib64/$(basename "$f")"
done
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib/lib_SoundBooster_ver1000.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/lib_SoundBooster_ver1000.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding Preload Apps"
DELETE_FROM_WORK_DIR "system" "system/preload"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/preload" 0 0 644
LOG_STEP_OUT

LOG_STEP_IN "- Adding Camera Blob"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libMultiFrameProcessing10.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libobjectcapture.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libobjectcapture_jni.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libphotohdr.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/liblow_light_hdr.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"

if [[ "$ROM_VERSION" == "Azure" ]]; then
ADD_TO_WORK_DIR "r11sxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r11sxxx" "system" "system/priv-app/SamsungCamera/SamsungCamera.apk.prof" 0 0 644 "u:object_r:system_file:s0"
fi
LOG_STEP_OUT

# Adding Overlay
GET_ONEUI() {
    local sdk_version="$1"

    case "$sdk_version" in
        34) echo "OneUI6" ;;
        35) echo "OneUI7" ;;
        36) echo "OneUI8" ;;
        37) echo "OneUI9" ;;
        *)
            local calculated=$(( sdk_version ))
            echo "OneUI$calculated"
            ;;
    esac
}

D_NAME=$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/ROM/system/system/build.prop" "ro.product.system.name")
SRC_FILE="$MODPATH/FixOverlay/framework-res__${D_NAME}__auto_generated_rro_product.apk"
FALLBACK_FILE="$MODPATH/FixOverlay/framework-res__${TARGET_CODENAME}__auto_generated_rro_product.apk"
DEST_FILE="$WORK_DIR/product/overlay/framework-res__${D_NAME}__auto_generated_rro_product.apk"

LOG_STEP_IN "- Adding Product Overlay"
    if [ -f "$SRC_FILE" ]; then
        cp "$SRC_FILE" "$DEST_FILE"
    elif [ -f "$FALLBACK_FILE" ]; then
        cp "$FALLBACK_FILE" "$DEST_FILE"
    else
        LOGE "ERROR: Tidak ada RRO yang cocok untuk $D_NAME"
    fi
LOG_STEP_OUT

# Disable ICCC
SET_PROP "system" "ro.config.iccc_version"

# Deleting Game Driver
LOG_STEP_IN "- Game Driver"
find "$WORK_DIR/system/system/priv-app" -name 'DevGPUDriver-*' -type d | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/priv-app/$(basename "$f")"
done
find "$WORK_DIR/system/system/priv-app" -name 'GameDriver-*' -type d | while read -r f; do
    DELETE_FROM_WORK_DIR "system" "system/priv-app/$(basename "$f")"
done
LOG_STEP_OUT

# Adding FM Radio
LOG_STEP_IN "- Adding FM Radio"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/etc/permissions/privapp-permissions-com.sec.android.app.fm.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/framework/samsungfmradiolib.jar" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libfmradio_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_CHIP_VENDOR" "7"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_COMMON_RSSI" "156"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_COMMON_SOFTMUTE_TH" "16"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_COMMON_SUPPORT_HYBRIDSEARCH" "0"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_REMOVE_AF_MENU" "TRUE"
LOG_STEP_OUT

# Adding BT Library Patcher
LOG_STEP_IN "- Adding BT Library Patcher"
ADD_TO_WORK_DIR "m21xnsxx" "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT