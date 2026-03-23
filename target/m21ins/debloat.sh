#
# Copyright (C) 2025 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Debloat list for Galaxy S21 FE 5G (Exynos) (r9s)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Overlays
#SYSTEM_DEBLOAT+="
#system/app/WifiRROverlayAppH2E
#"

# Memory
SYSTEM_DEBLOAT+="
system/system_ext/lib
system/system_ext/lib64
"

# mAFPC
SYSTEM_DEBLOAT+="
system/bin/mafpc_write
"

# EarphoneTypeC
SYSTEM_DEBLOAT+="
system/priv-app/EarphoneTypeC
system/etc/permissions/privapp-permissions-com.samsung.android.app.earphonetypec.xml
"

# Google Messages
PRODUCT_DEBLOAT+="
priv-app/Messages
"

# Parental Controls
PRODUCT_DEBLOAT+="
priv-app/FamilyLinkParentalControls
"

# Secure Folder
#SYSTEM_DEBLOAT+="
#system/priv-app/SecureFolder
#"

# Interpreter
SYSTEM_DEBLOAT+="
system/priv-app/BixbyInterpreter
"

# Ultra Data Saving
SYSTEM_DEBLOAT+="
system/priv-app/UltraDataSaving_O
"

# SkyUI Debloat
SYSTEM_DEBLOAT+="
system/app/CarrierDefaultApp
system/app/ccinfo
system/app/ChromeCustomizations
system/app/Fast
system/app/KidsHome_Installer
system/app/MDMApp
system/app/Rampart
system/app/SilentLog
system/app/SimAppDialog
system/app/Traceur
system/app/UniversalMDMClient
system/app/WifiGuider
system/app/AASAservice
system/app/ARCore
system/app/BasicDreams
system/app/BBCAgent
system/app/BixbyWakeup
system/app/BookmarkProvider
system/app/GearManagerStub
system/app/MyDevice
system/app/ParentalCare
system/app/SafetyInformation
system/app/SmartSwitchStub
system/app/SmartSwitchAgent
system/app/VTCameraSetting
system/etc/default-permissions/default-permissions-com.sec.spp.push.xml
system/etc/permissions/com.samsung.feature.samsungpositioning.xml
system/etc/permissions/privapp-permissions-com.samsung.android.samsungpositioning.xml
system/etc/permissions/privapp-permissions-com.samsung.oda.service.xml
system/etc/permissions/privapp-permissions-com.sec.imslogger.xml
system/etc/permissions/privapp-permissions-com.sec.spp.push.xml
system/etc/permissions/privapp-permissions-com.skms.android.agent.xml
system/etc/PF_TA
system/etc/sysconfig/samsungpushservice.xml
system/priv-app/AREmoji
system/priv-app/CpAgent
system/priv-app/EnhancedAttestationAgent
system/priv-app/ImsLogger
system/priv-app/OdaService
system/priv-app/OMCAgent5
system/priv-app/SamsungPositioning
system/priv-app/SKMSAgent
system/priv-app/SPPPushClient
system/priv-app/StickerFaceARAvatar
system/priv-app/Bixby
system/priv-app/BixbyVisionFramework3.5
system/priv-app/Crane
system/priv-app/CSC
system/priv-app/DeviceBasedServiceConsent
system/priv-app/DynamicSystemInstallationService
system/priv-app/GameOptimizingService
system/priv-app/GlobalPostProcMgr
system/priv-app/HashTagService
system/priv-app/HWResourceShare
system/priv-app/KLMSAgent
system/priv-app/MobileWips
system/priv-app/NSDSWebApp
system/priv-app/PhoneNumberService
system/priv-app/SamsungBilling
system/priv-app/SamsungMagnifier3
system/priv-app/SamsungSeAgent
system/priv-app/SCameraSDKService
system/priv-app/sec_camerax_service
system/priv-app/serviceModeApp_FB
system/priv-app/SmartEpdgTestApp
system/priv-app/SmartSwitchAssistant
system/priv-app/SmartThingsKit
system/priv-app/SohService
system/priv-app/Tag
system/priv-app/TalkbackSE
system/app/MoccaMobile
system/app/SamsungOne
system/app/SimMobilityKit
system/app/StickerCenter
system/app/WifiAiService
system/app/TEEgrisTuiService
system/priv-app/AutoDoodle
system/priv-app/AvatarPicker
system/priv-app/CallContentProvider
system/priv-app/CIDManager
system/priv-app/DigitalWellbeing
system/priv-app/EasySetup
system/priv-app/EmergencySOS
system/priv-app/GameTools_Dream
system/priv-app/HdmApk
system/priv-app/KmxService
system/priv-app/KnoxZtFramework
system/priv-app/LocalTransport
system/priv-app/NetworkDiagnostic
system/priv-app/NSFusedLocation_v6.0
system/priv-app/PetService
system/priv-app/QMDService
system/priv-app/SDMConfig
system/priv-app/vexfwk_service
system/priv-app/VexScanner
system/priv-app/VideoScan
system/bin/heatmap
"

# Knox App
SYSTEM_DEBLOAT+="
system/priv-app/KnoxGuard
system/priv-app/KPECore
system/priv-app/KnoxCore
system/priv-app/KnoxERAgent
system/priv-app/KnoxFrameBufferProvider
system/priv-app/KnoxNetworkFilter
system/priv-app/KnoxNeuralNetworkRuntime
system/priv-app/KnoxPushManager
system/priv-app/KnoxSandbox
system/priv-app/knoxanalyticsagent
system/priv-app/knoxvpnproxyhandler
system/etc/permissions/privapp-permissions-com.knox.vpn.proxyhandler.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.analytics.uploader.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.app.networkfilter.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.er.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.kfbp.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.knnr.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.kpecore.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.pushmanager.xml
system/etc/permissions/privapp-permissions-com.samsung.android.knox.sandbox.xml
system/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml
"

# Bloack Chain
SYSTEM_DEBLOAT+="
system/app/BlockchainBasicKit
"

# Mpos
SYSTEM_DEBLOAT+="
system/priv-app/KnoxMposAgent
system/etc/permissions/privapp-permissions-com.samsung.android.knox.mpos.xml
"

# eSE COS
SYSTEM_DEBLOAT+="
system/priv-app/SEMFactoryApp
system/etc/permissions/privapp-permissions-com.sem.factoryapp.xml
"

# Knox Matrix
SYSTEM_DEBLOAT+="
system/bin/fabric_crypto
system/etc/init/fabric_crypto.rc
system/etc/permissions/FabricCryptoLib.xml
system/etc/permissions/privapp-permissions-com.samsung.android.kmxservice.xml
system/etc/vintf/manifest/fabric_crypto_manifest.xml
system/framework/FabricCryptoLib.jar
system/lib64/com.samsung.security.fabric.cryptod-V1-cpp.so
system/priv-app/KmxService
"

# Live Effect Service
SYSTEM_DEBLOAT+="
system/priv-app/LiveEffectService
"

# Google
PRODUCT_DEBLOAT+="
priv-app/Velvet
"
