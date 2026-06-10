#!/system/bin/sh
SKIPUNZIP=1

ui_print "- Downloading Material Files (latest)..."

APK_URL="https://github.com/zhanghai/MaterialFiles/releases/latest/download/app-release-universal.apk"
DEST="$MODPATH/system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk"

mkdir -p "$MODPATH/system/priv-app/DocumentsUIGoogle"

# Try curl first, fall back to wget
if command -v curl >/dev/null 2>&1; then
    curl -L --fail -o "$DEST" "$APK_URL"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$DEST" "$APK_URL"
else
    ui_print "! ERROR: No download tool available (curl/wget)"
    exit 1
fi

if [ ! -s "$DEST" ]; then
    ui_print "! ERROR: Download failed or file is empty"
    exit 1
fi

ui_print "- Download complete"
ui_print "- Setting permissions..."
set_perm "$DEST" root root 0644
ui_print "- Disabling stock DocumentsUIGoogle..."
pm disable com.google.android.documentsui 2>/dev/null || true

ui_print "- Done! Reboot to activate. ╰⋃╯"