source "$PATCH_DIR/skyui/configs/version.sh" || exit 1

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"

LOG_STEP_IN "- Adding SkyUI Info"
    LOG_STEP_IN "- Copy SecSettings Files"
        cp -a "$MODPATH/SecSettings.apk/." "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk"
    LOG_STEP_OUT
	
	LOG_STEP_IN "- Apply Patch SecSettings"
        APPLY_PATCH "system" "system/priv-app/SecSettings/SecSettings.apk" "$MODPATH/0001-Adding-SkyUI-Info.patch"
    LOG_STEP_OUT

    SET_PROP "system" "ro.skyui.codename" "$ROM_VERSION"
    SET_PROP "system" "ro.skyui.version" "$MAJOR_PATCH"
    SET_PROP "system" "ro.skyui.buildtype" "$BUILD_VERSION"

LOG_STEP_OUT