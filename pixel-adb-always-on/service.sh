#!/system/bin/sh
# ─────────────────────────────────────────────────────────────
# Pixel ADB Always On — service.sh
# Applies ADB mode on boot based on saved config
# ─────────────────────────────────────────────────────────────

MODDIR="${0%/*}"
CONF_FILE="/data/adb/modules/pixel-adb-always-on/adb_mode"

# Wait for boot to complete (60 s timeout)
WAIT=0
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
    WAIT=$((WAIT + 2))
    [ "$WAIT" -ge 60 ] && exit 1
done

# Suppress "ADB connected" notification
resetprop persist.adb.notify 0

# Read saved mode (default to "both" if config missing)
MODE=$(cat "$CONF_FILE" 2>/dev/null | tr -d '[:space:]')
[ -z "$MODE" ] && MODE="both"

case "$MODE" in
    wireless)
        # Wireless ADB only — no USB ADB, MTP still available
        resetprop sys.usb.config mtp
        resetprop sys.usb.state mtp
        resetprop service.adb.tcp.port 5555
        stop adbd
        start adbd
        ;;
    usb)
        # USB ADB + MTP — no wireless
        resetprop sys.usb.config mtp,adb
        resetprop sys.usb.state mtp,adb
        resetprop service.adb.tcp.port -1
        stop adbd
        start adbd
        ;;
    both|*)
        # Wireless ADB + USB ADB + MTP
        resetprop sys.usb.config mtp,adb
        resetprop sys.usb.state mtp,adb
        resetprop service.adb.tcp.port 5555
        stop adbd
        start adbd
        ;;
esac
