#Disable DualDAR Version
DECODE_APK "system" "system/framework/knoxsdk.jar"
DECODE_APK "system_ext" "priv-app/StorageManager/StorageManager.apk"

LOG "- Disable DualDAR Version in system/framework/knoxsdk.jar"
sed -i 's/^[[:space:]]*const-string v0, "1\.7\.0"/    const\/4 v0, 0x0/' \
$APKTOOL_DIR/system/framework/knoxsdk.jar/smali/com/samsung/android/knox/ddar/DualDARPolicy.smali

LOG "- Disable DualDAR Version in system_ext/priv-app/StorageManager/StorageManager.apk"
sed -i 's/^[[:space:]]*const-string v0, "1\.7\.0"/    const\/4 v0, 0x0/' \
$APKTOOL_DIR/system_ext/priv-app/StorageManager/StorageManager.apk/smali/com/samsung/android/knox/ddar/DualDARPolicy.smali