#!/system/bin/sh
# ─────────────────────────────────────────────────────────────
# Pixel ADB Always On — uninstall.sh
# Called by Magisk when the module is removed
# ─────────────────────────────────────────────────────────────

# Remove config
rm -f /data/adb/modules/pixel-adb-always-on/adb_mode

# Restore ADB notification default
resetprop --delete persist.adb.notify

# Disable TCP ADB and restart in USB-only default
resetprop service.adb.tcp.port -1
stop adbd
start adbd
