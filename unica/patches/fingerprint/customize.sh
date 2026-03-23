# [
GET_FP_SENSOR_TYPE()
{
    if [[ "$1" == *"ultrasonic"* ]]; then
        echo "ultrasonic"
    elif [[ "$1" == *"optical"* ]]; then
        echo "optical"
    elif [[ "$1" == *"side"* ]]; then
        echo "side"
    else
        LOGE "Unsupported type: \"$1\""
    fi
}
# ]

MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if [[ "$SOURCE_FINGERPRINT_CONFIG_SENSOR" != "$TARGET_FINGERPRINT_CONFIG_SENSOR" ]]; then
    LOG_STEP_IN "- Applying fingerprint sensor patches"

    DECODE_APK "system" "system/framework/framework.jar"
    DECODE_APK "system" "system/framework/services.jar"
    DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
    DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"

    FTP="
    system/framework/framework.jar/smali_classes2/android/hardware/fingerprint/FingerprintManager.smali
    system/framework/framework.jar/smali_classes2/android/hardware/fingerprint/HidlFingerprintSensorConfig.smali
    system/framework/framework.jar/smali_classes5/com/samsung/android/bio/fingerprint/SemFingerprintManager.smali
    system/framework/framework.jar/smali_classes5/com/samsung/android/bio/fingerprint/SemFingerprintManager\$Characteristics.smali
    system/framework/framework.jar/smali_classes6/com/samsung/android/rune/InputRune.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/biometrics/fingerprint/FingerprintEntry.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/biometrics/fingerprint/FingerprintLockSettings.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_FINGERPRINT_CONFIG_SENSOR/$TARGET_FINGERPRINT_CONFIG_SENSOR/g" "$APKTOOL_DIR/$f"
    done

    if [[ "$(GET_FP_SENSOR_TYPE "$TARGET_FINGERPRINT_CONFIG_SENSOR")" == "ultrasonic" ]]; then
        DECODE_APK "system" "system/priv-app/BiometricSetting/BiometricSetting.apk"
        ADD_TO_WORK_DIR "e1sxxx" "system" "system/bin/surfaceflinger"
        ADD_TO_WORK_DIR "e1sxxx" "system" "system/lib64/libgui.so"
        ADD_TO_WORK_DIR "e1sxxx" "system" "system/lib64/libui.so"
        APPLY_PATCH "system" "system/framework/services.jar" "$MODPATH/fingerprint/services.jar/0001-Set-FP_FEATURE_SENSOR_IS_OPTICAL-to-false.patch"
        APPLY_PATCH "system" "priv-app/BiometricSetting/BiometricSetting.apk" "$MODPATH/fingerprint/BiometricSetting.apk/0001-Set-FP_FEATURE_SENSOR_IS_OPTICAL-to-false.patch"
        APPLY_PATCH "system_ext" "priv-app/SystemUI/SystemUI.apk" "$$MODPATH/fingerprint/SystemUI.apk/0001-Set-SECURITY_FINGERPRINT_IN_DISPLAY_OPTICAL-to-false.patch"
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_BIOAUTH_CONFIG_FINGERPRINT_FEATURES" "ultrasonic_display_phone"
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_LCD_CONFIG_LOCAL_HBM" "0"
    elif [[ "$(GET_FP_SENSOR_TYPE "$TARGET_FINGERPRINT_CONFIG_SENSOR")" == "side" ]]; then
        ADD_TO_WORK_DIR "b6qxxx" "system" "."
        DELETE_FROM_WORK_DIR "system" "system/priv-app/BiometricSetting/oat"
        APPLY_PATCH "system" "system/framework/services.jar" "$MODPATH/fingerprint/services.jar/0001-Set-Fingerprint-Sensor-Ultrasonic-To-False.patch"
        APPLY_PATCH "system_ext" "priv-app/SystemUI/SystemUI.apk" "$MODPATH/fingerprint/SystemUI.apk/0001-Set-Security-Fingerprint-In-Display-to-Flase.patch"
    fi
    LOG_STEP_OUT
fi

if [[ "$(GET_FP_SENSOR_TYPE "$TARGET_FINGERPRINT_CONFIG_SENSOR")" == "optical" ]]; then
    LOG "- Adding Ultrasonic FOD Animation"

    DECODE_APK "system" "system/priv-app/BiometricSetting/BiometricSetting.apk"

    FTP="
    system/priv-app/BiometricSetting/BiometricSetting.apk/smali/com/samsung/android/biometrics/app/setting/fingerprint/vi/VisualEffectContainer.smali
    "
    for f in $FTP; do
        sed -i "s/green_circle/ripple/g" "$APKTOOL_DIR/$f"
        sed -i "s/white_circle/ripple/g" "$APKTOOL_DIR/$f"
    done
fi


