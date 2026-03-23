DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

APK_PATH="system/priv-app/SecSettings/SecSettings.apk"
BASE_DIR="smali_classes4/com/samsung/android/settings/deviceinfo/aboutphone"

LOC1="$BASE_DIR/DeviceImageManager\$1.smali"
LOC2="$BASE_DIR/deviceimage/DeviceImageManager\$1.smali"

if [ -f "$APKTOOL_DIR/$APK_PATH/$LOC1" ]; then
    TARGET_SMALI="$LOC1"
elif [ -f "$APKTOOL_DIR/$APK_PATH/$LOC2" ]; then
    TARGET_SMALI="$LOC2"
else
    echo "Error: File DeviceImageManager\$1.smali tidak ditemukan!"
    exit 1
fi

LOG_STEP_IN "- Applying Device Image patches"
SMALI_PATCH "system" "$APK_PATH" \
            "$TARGET_SMALI" "replace" \
            "run()V" \
            "ril.product_code" \
            "ro.skyui.product_code"
LOG_STEP_OUT

LOG_STEP_IN "- Applying Selinux Permission"

FILE="$WORK_DIR/system/system/etc/selinux/plat_property_contexts"
LINE="ro.skyui.product_code u:object_r:build_prop:s0 exact string"

if grep -Fxq "$LINE" "$FILE"; then
    LOGW "Selinux context already exists, skipping"
else
    EVAL "echo \"$LINE\" >> \"$FILE\""
    LOG "- Adding Selinux context "$LINE""
fi

LOG_STEP_OUT

LOG_STEP_IN "- Set Prop ro.skyui.product_code"
SET_PROP "system" "ro.skyui.product_code" "$(GET_PROP "$FW_DIR/$SOURCE_FIRMWARE_PATH/ROM/system/system/build.prop" "ro.product.system.model")"
LOG_STEP_OUT