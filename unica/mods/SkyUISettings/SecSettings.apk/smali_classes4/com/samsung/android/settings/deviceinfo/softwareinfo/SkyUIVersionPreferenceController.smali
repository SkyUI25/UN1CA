.class public Lcom/samsung/android/settings/deviceinfo/softwareinfo/SkyUIVersionPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "SkyUIVersionPreferenceController.java"

.field private static final LOG_TAG:Ljava/lang/String; = "SkyUIVersionPreferenceCtr"

# ======================
# Constructor
# ======================
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V
    return-void
.end method

# ======================
# Main display version (safe)
# ======================
.method private getDisplayVersion()Ljava/lang/CharSequence;
    .locals 14

    :try_start

    # ambil property sebagai STRING (lebih aman)
    const-string v0, "ro.skyui.version"
    const-string v1, "0"
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    # parse manual, fallback di catch kalau error
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    move-result v0

    const-string v1, "ro.skyui.codename"
    const-string v2, "SkyUI"
    invoke-static {v1, v2}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    const-string v2, "ro.skyui.buildtype"
    const-string v3, "Stable"
    invoke-static {v2, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2

    # validasi kosong
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :default_return

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :default_return

    if-lez v0, :default_return

    # ======================
    # Hitung Major / Minor / Patch
    # version = 800000 -> major=8, minor=0, patch=0
    # ======================
    const v3, 100000       # major divider
    div-int v4, v0, v3     # major

    const/16 v5, 1000
    div-int v6, v0, v5
    const/16 v7, 100
    rem-int v6, v6, v7     # minor

    rem-int v7, v0, v7     # patch

    # ======================
    # Build string
    # ======================
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, " "
    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, "."
    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    if-lez v7, :skip_patch
    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    :skip_patch

    const-string v1, " - "
    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9

    # ======================
    # Spannable warna buildtype
    # ======================
    new-instance v10, Landroid/text/SpannableString;
    invoke-direct {v10, v9}, Landroid/text/SpannableString;-><init>(Ljava/lang/CharSequence;)V

    invoke-virtual {v9, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I
    move-result v11
    if-ltz v11, :return_normal

    invoke-virtual {v2}, Ljava/lang/String;->length()I
    move-result v12
    add-int/2addr v12, v11

    const-string v13, "Beta"
    invoke-virtual {v2, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v13
    if-eqz v13, :check_alpha
    const v13, 0xFFFFC107    # Kuning
    goto :apply_color

    :check_alpha
    const-string v13, "Alpha"
    invoke-virtual {v2, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v13
    if-eqz v13, :return_normal
    const v13, 0xFFF44336    # Merah
    :apply_color
    new-instance v2, Landroid/text/style/ForegroundColorSpan;
    invoke-direct {v2, v13}, Landroid/text/style/ForegroundColorSpan;-><init>(I)V
    const/16 v13, 0x21
    invoke-virtual {v10, v2, v11, v12, v13}, Landroid/text/SpannableString;->setSpan(Ljava/lang/Object;III)V

    return-object v10

    :return_normal
    return-object v9

    :default_return
    const-string v0, "SkyUI 8.0 - Stable"
    return-object v0

    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_block

    :catch_block
    const-string v0, "SkyUI 8.0 - Stable"
    return-object v0
.end method

# ======================
# Base Methods Overrides
# ======================
.method public getAvailabilityStatus()I
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public getSummary()Ljava/lang/CharSequence;
    .locals 1
    invoke-direct {p0}, Lcom/samsung/android/settings/deviceinfo/softwareinfo/SkyUIVersionPreferenceController;->getDisplayVersion()Ljava/lang/CharSequence;
    move-result-object v0
    return-object v0
.end method

.method public isControllable()Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public bridge synthetic getBackgroundWorkerClass()Ljava/lang/Class;
    .locals 0
    const/4 v0, 0x0
    return-object v0
.end method

.method public bridge synthetic getLaunchIntent()Landroid/content/Intent;
    .locals 0
    const/4 v0, 0x0
    return-object v0
.end method