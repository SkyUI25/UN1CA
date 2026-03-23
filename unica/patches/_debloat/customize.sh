# Dexpreopt
LOG_STEP_IN true "Checking then Removing oat directories..."
mapfile -t TARGET_DIRS < <(
    find "$WORK_DIR/system" "$WORK_DIR/product" -type d -name "oat"
)

if [ "${#TARGET_DIRS[@]}" -eq 0 ]; then
    LOGW "No oat directories found"
else
    for dir in "${TARGET_DIRS[@]}"; do
        rm -rf "$dir" && LOG "Deleted: $dir" || LOGE "Failed: $dir"
    done
fi
LOG_STEP_OUT

LOG_STEP_IN true "Checking then Removing *.vdex file..."
mapfile -t TARGET_DIRS < <(
    find "$WORK_DIR/system/system/framework" -type f -name "*.vdex"
)

if [ "${#TARGET_DIRS[@]}" -eq 0 ]; then
    LOGW "No oat directories found"
else
    for dir in "${TARGET_DIRS[@]}"; do
        rm -rf "$dir" && LOG "Deleted: $dir" || LOGE "Failed: $dir"
    done
fi
LOG_STEP_OUT

DELETE_FROM_WORK_DIR "system" "system/etc/boot-image.bprof"
DELETE_FROM_WORK_DIR "system" "system/etc/boot-image.prof"
DELETE_FROM_WORK_DIR "system" "system/framework/arm"
DELETE_FROM_WORK_DIR "system" "system/framework/arm64"

if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
    find "$WORK_DIR/system_ext" -type d -name "oat" -print0 | xargs -0 -I "{}" -P "$(nproc)" \
        bash -c 'source "$SRC_DIR/scripts/utils/module_utils.sh"; DELETE_FROM_WORK_DIR "system_ext" "${1//$WORK_DIR\/system_ext\//}"' "bash" "{}"
fi


# Debloat
for f in \
    "$SRC_DIR/unica/debloat.sh" \
    "$SRC_DIR/platform/$TARGET_PLATFORM/debloat.sh" \
    "$SRC_DIR/target/$TARGET_CODENAME/debloat.sh"
do
    [[ -f "$f" ]] && source "$f"
done

normalize_list() {
    sed '/^$/d' | sort -u
}

ODM_DEBLOAT="$(normalize_list <<< "$ODM_DEBLOAT")"
PRODUCT_DEBLOAT="$(normalize_list <<< "$PRODUCT_DEBLOAT")"
SYSTEM_DEBLOAT="$(normalize_list <<< "$SYSTEM_DEBLOAT")"
SYSTEM_EXT_DEBLOAT="$(normalize_list <<< "$SYSTEM_EXT_DEBLOAT")"
VENDOR_DEBLOAT="$(normalize_list <<< "$VENDOR_DEBLOAT")"

fast_debloat() {
    local PART="$1"
    local LIST="$2"
    local BASE="$WORK_DIR/$PART"

    [[ -z "$LIST" ]] && return 0

    LOG_STEP_IN true "Debloating $PART..."

    while IFS= read -r item; do
        [[ -z "$item" ]] && continue

        # buang prefix partition (biarkan seperti ini, SUDAH WORKING)
        clean="${item#$PART/$LIST}"
        target="$BASE/$clean"

        if [[ -e "$target" ]]; then
            rm -rf "$target" \
                && LOG "Removed: $PART/$clean" \
                || LOGE "Failed: $PART/$clean"
        else
            LOGW "Not found: $PART/$clean"
        fi
    done <<< "$LIST"

    LOG_STEP_OUT
}

fast_debloat odm        "$ODM_DEBLOAT"
fast_debloat product    "$PRODUCT_DEBLOAT"
fast_debloat system     "$SYSTEM_DEBLOAT"
fast_debloat system_ext "$SYSTEM_EXT_DEBLOAT"
fast_debloat vendor     "$VENDOR_DEBLOAT"


unset ODM_DEBLOAT PRODUCT_DEBLOAT SYSTEM_DEBLOAT SYSTEM_EXT_DEBLOAT VENDOR_DEBLOAT
