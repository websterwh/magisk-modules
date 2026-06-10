#!/system/bin/sh

APK_URL="https://github.com/zhanghai/MaterialFiles/releases/latest/download/app-release-universal.apk"
DEST="$MODPATH/system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk"
TMP="/data/local/tmp/materialfiles-update.apk"

echo "Checking for latest Material Files version..."

# Get latest version tag from GitHub API
LATEST=$(curl -sL "https://api.github.com/repos/zhanghai/MaterialFiles/releases/latest" \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$LATEST" ]; then
    echo "ERROR: Could not fetch version info. Check your internet connection."
    exit 1
fi

echo "Latest version: $LATEST"

# Get installed version
INSTALLED=$(dumpsys package me.zhanghai.android.files \
    | grep versionName \
    | head -1 \
    | sed 's/.*versionName=\([^ ]*\).*/\1/')

echo "Installed version: ${INSTALLED:-unknown}"

if [ "v$INSTALLED" = "$LATEST" ]; then
    echo "Already up to date!"
    exit 0
fi

echo "Update available: $INSTALLED -> $LATEST"
echo "Downloading..."

curl -L --fail -o "$TMP" "$APK_URL"

if [ ! -s "$TMP" ]; then
    echo "ERROR: Download failed."
    rm -f "$TMP"
    exit 1
fi

echo "Installing to module..."
cp "$TMP" "$DEST"
set_perm "$DEST" root root 0644
rm -f "$TMP"

echo "Done! Reboot to apply update."