DECODE_APK "system" "system/framework/services.jar"

########### Fix Secure Folder
LOG_STEP_IN "- Fix Secure Folder"
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/DarManagerService.smali" \
    "return" \
    "isDeviceRootKeyInstalled()Z" 'true'
	
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/knox/dar/DarManagerService.smali" \
    "return" \
    "isKnoxKeyInstallable()Z" 'true'

LOG_STEP_OUT