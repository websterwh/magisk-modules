#!/system/bin/sh
# ─────────────────────────────────────────────
# Pixel ADB Always On — service.sh
# Runs after Magisk mounts; waits for full boot
# ─────────────────────────────────────────────

MODDIR="${0%/*}"

# Wait for boot to complete (60 s timeout)
WAIT=0
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
    WAIT=$((WAIT + 2))
    [ "$WAIT" -ge 60 ] && exit 1
done

# Suppress "ADB connected" notification
resetprop persist.adb.notify 0

# Set USB mode to MTP + ADB
resetprop sys.usb.config mtp,adb
resetprop sys.usb.state mtp,adb

# Enable ADB over TCP on port 5555
resetprop service.adb.tcp.port 5555
stop adbd
start adbd
