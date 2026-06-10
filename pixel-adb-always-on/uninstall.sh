#!/system/bin/sh
# ─────────────────────────────────────────────
# Pixel ADB Always On — uninstall.sh
# Called by Magisk when the module is removed
# ─────────────────────────────────────────────

# Restore ADB notification default
resetprop --delete persist.adb.notify

# Clear TCP port and restart ADB in USB-only mode
resetprop service.adb.tcp.port -1
stop adbd
start adbd
