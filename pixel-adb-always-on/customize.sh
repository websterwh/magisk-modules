#!/system/bin/sh
# ─────────────────────────────────────────────────────────────
# Pixel ADB Always On — customize.sh
# Runs at flash time to let the user pick a mode via volume keys
# ─────────────────────────────────────────────────────────────

# Config file lives in the module's data directory (persists across updates)
CONF_DIR="/data/adb/modules/pixel-adb-always-on"
CONF_FILE="$CONF_DIR/adb_mode"

mkdir -p "$CONF_DIR"

ui_print ""
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "   Pixel ADB Always On"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print ""
ui_print "  Select ADB mode:"
ui_print "  Vol ▲  →  Wireless ADB only (TCP port 5555)"
ui_print "  Vol ▼  →  USB ADB + MTP only"
ui_print "  (none) →  Both (default)"
ui_print ""

# 5-second countdown — capture a volume key via getevent
# getevent -lqc 1 grabs one input event; we background it and poll
KEY="both"
GETEVENT_OUT="$TMPDIR/ge_out"

/system/bin/getevent -lqc 1 > "$GETEVENT_OUT" 2>/dev/null &
GE_PID=$!

COUNT=5
while [ $COUNT -gt 0 ]; do
    ui_print "  Press now... $COUNT"
    sleep 1
    COUNT=$((COUNT - 1))
    # Check if getevent already captured something
    if ! kill -0 $GE_PID 2>/dev/null; then
        break
    fi
done

# Kill getevent if still running (timeout reached)
kill $GE_PID 2>/dev/null
wait $GE_PID 2>/dev/null

if grep -q "KEY_VOLUMEUP" "$GETEVENT_OUT" 2>/dev/null; then
    KEY="up"
elif grep -q "KEY_VOLUMEDOWN" "$GETEVENT_OUT" 2>/dev/null; then
    KEY="down"
fi

rm -f "$GETEVENT_OUT"

case "$KEY" in
    up)
        echo "wireless" > "$CONF_FILE"
        ui_print "  ✓ Mode set: Wireless ADB only"
        ;;
    down)
        echo "usb" > "$CONF_FILE"
        ui_print "  ✓ Mode set: USB ADB + MTP only"
        ;;
    *)
        echo "both" > "$CONF_FILE"
        ui_print "  ✓ Mode set: Wireless ADB + USB ADB + MTP (default)"
        ;;
esac

ui_print ""
ui_print "  Mode can be changed anytime via"
ui_print "  the module's Action button in Magisk."
ui_print ""
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
