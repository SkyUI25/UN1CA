DECODE_APK "system" "system/framework/knoxsdk.jar"

########### Fix Samsung Healt
LOG_STEP_IN "- Fix Samsung Healt"
SMALI_PATCH "system" "system/framework/knoxsdk.jar" \
    "smali/com/samsung/android/knox/EdmUtils.smali" \
    "return" \
    "getAPILevelForInternal()I" \
    "0x13"

LOG_STEP_OUT