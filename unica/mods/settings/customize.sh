LOG_STEP_IN "- Enabling BSOH in SecSettings"

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

FTP="
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/BatteryRegulatoryPreferenceController.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/SecBatteryFirstUseDatePreferenceController.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/deviceinfo/batteryinfo/SecBatteryInfoFragment.smali
"
for f in $FTP; do
    sed -i "s/SM-A236B/$(GET_PROP "system" "ro.product.system.model")/g" "$APKTOOL_DIR/$f"
done
LOG_STEP_OUT

LOG_STEP_IN "- Adding Multi-User Support"
SET_PROP "system" "fw.max_users" "8"
SET_PROP "system" "fw.show_multiuserui" "1"
LOG_STEP_OUT

# ro.build.2ndbrand is always "false"
DECODE_APK "system" "system/framework/services.jar"
LOG_STEP_IN "- Disabling ASKS"
sed -i "s/ro.build.official.release/ro.build.2ndbrand/g" "$APKTOOL_DIR/system/framework/services.jar/smali/com/android/server/asks/ASKSManagerService.smali"
LOG_STEP_OUT

DECODE_APK "system" "system/framework/services.jar"

########### Allow secure screenshot
LOG_STEP_IN "- Allow secure screenshot"
SMALI_PATCH "system" "system/framework/services.jar" \
        "smali_classes2/com/android/server/wm/WindowState.smali" "return" \
        'isSecureLocked()Z' 'false'
LOG_STEP_OUT

########### Allow app downgrade
LOG_STEP_IN "- Allow app downgrade"
SMALI_PATCH "system" "system/framework/services.jar" \
        "smali_classes2/com/android/server/pm/PackageManagerServiceUtils.smali" "return" \
        'isDowngradePermitted(IZ)Z' 'false'
LOG_STEP_OUT

########### Bypass app target SDK
LOG_STEP_IN "- Bypass app target SDK"
FILE="$APKTOOL_DIR/system/framework/services.jar/smali_classes2/com/android/server/pm/InstallPackageHelper.smali"

# Patch the file using sed
sed -i '/and-int\/2addr v2, v10/,/if-nez v2, :cond_14/c\
    and-int\/2addr v2, v10\
    if-eqz v2, :cond_13\
\
    const/4 v2, 0x1\
\
    goto :goto_d\
\
    :cond_13\
    const/4 v2, 0x1\
\
    :goto_d\
    if-nez v2, :cond_14' "$FILE"

# Verifikasi patch
if sed -n '/and-int\/2addr v2, v10/,/if-nez v2, :cond_14/p' "$FILE" | grep -q "const/4 v2, 0x1"; then
    LOG "[SUCCESS] Bypass app target SDK patched successfully!"
else
    LOGE "[FAIL] Bypass app target SDK patch failed!"
    exit 1
fi
LOG_STEP_OUT

########### Set auto confirm PIN min digits to 4
LOG_STEP_IN "- Set auto confirm PIN min digits to 4"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/locksettings/SyntheticPasswordManager.smali" "replace" \
    'createLskfBasedProtector(Landroid/service/gatekeeper/IGateKeeperService;Lcom/android/internal/widget/LockscreenCredential;JLcom/android/internal/widget/LockscreenCredential;Lcom/android/server/locksettings/SyntheticPasswordManager$SyntheticPassword;I)J' \
    'const/4 v9, 0x6' \
    'const/4 v9, 0x4'
LOG_STEP_OUT

########### Allow Zipped Overlay APKs
#LOG_STEP_IN "- Allow Zipped Overlay APKs"
#FILE="$APKTOOL_DIR/system/framework/services.jar/smali_classes2/com/android/server/pm/InstallPackageHelper.smali"

#sed -i '/invoke-virtual {v3, v6}, Ljava\/lang\/String;->startsWith(Ljava\/lang\/String;)Z/,/if-eqz v0, :cond_c/c\
#    invoke-virtual {v3, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z\
#\
#    move-result v3\
#\
#    goto :cond_d\
#\
#    if-eqz v0, :cond_c' "$FILE"

# Verifikasi
#if grep -q "goto :cond_d" "$FILE"; then
#    LOG "[SUCCESS] Allow Zipped Overlay APKs patched successfully!"
#else
#    LOGE "[FAIL] Allow Zipped Overlay APKs patch failed!"
#    exit 1
#fi

#LOG_STEP_OUT

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

########### Enable Outdoor mode support
LOG_STEP_IN "- Enable Outdoor mode support"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
        "smali_classes4/com/samsung/android/settings/display/controller/SecOutDoorModePreferenceController.smali" "return" \
        'isAvailable()Z' 'true'
LOG_STEP_OUT

########### Set auto confirm PIN min digits to 4
LOG_STEP_IN "- Set auto confirm PIN min digits to 4"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/password/ChooseLockPassword\$ChooseLockPasswordFragment.smali" "replace" \
    'handleNext$2()V' \
    'const/4 v4, 0x6' \
    'const/4 v4, 0x4'

SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "smali_classes2/com/android/settings/password/ChooseLockPassword\$ChooseLockPasswordFragment.smali" "replace" \
    'setAutoPinConfirmOption(IZ)V' \
    'const/4 p2, 0x6' \
    'const/4 p2, 0x4'
LOG_STEP_OUT

########### Enable gestures by default
LOG_STEP_IN "- Enable gestures by default"
SMALI_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" \
        "smali_classes4/com/samsung/android/settings/navigationbar/NavigationBarSettingsUtil.smali" "return" \
        'isGestureDefault()Z' 'true'
LOG_STEP_OUT

