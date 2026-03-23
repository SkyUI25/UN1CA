DECODE_APK "system" "system/framework/samsungkeystoreutils.jar"
DECODE_APK "system" "system/framework/services.jar"

LOG_STEP_IN "- Bypass ICD verification"
SMALI_PATCH "system" "system/framework/samsungkeystoreutils.jar" \
        "smali/com/samsung/android/security/keystore/AttestParameterSpec.smali" "return" \
        'isVerifiableIntegrity()Z' 'true'
		
SMALI_FILE="$APKTOOL_DIR/system/framework/services.jar/smali_classes2/com/samsung/android/security/keystore/AttestParameterSpec.smali"

sed -i '/iput-boolean p2, p0, Lcom\/samsung\/android\/security\/keystore\/AttestParameterSpec;->mDeviceAttestation:Z/ {
n
i\
\
    const/4 p3, 0x1
}' "$SMALI_FILE"

LOG "Insert const/4 p3, 0x1 applied."

LOG_STEP_OUT
