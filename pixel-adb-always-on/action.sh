#!/system/bin/sh
# ─────────────────────────────────────────────────────────────
# Pixel ADB Always On — action.sh
# Runs when user taps the Action button in the Magisk app.
# Shows a volume key prompt to pick a new mode, then applies
# it live without requiring a reboot where possible.
# ─────────────────────────────────────────────────────────────

CONF_FILE="/data/adb/modules/pixel-adb-always-on/adb_mode"

CURRENT=$(cat "$CONF_FILE" 2>/dev/null | tr -d '[:space:]')
[ -z "$CURRENT" ] && CURRENT="both"

# Show current mode
case "$CURRENT" in
    wireless) CURRENT_LABEL="Wireless ADB only"         ;;
    usb)      CURRENT_LABEL="USB ADB + MTP only"        ;;
    both)     CURRENT_LABEL="Wireless ADB + USB ADB + MTP" ;;
    *)        CURRENT_LABEL="Unknown"                   ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Pixel ADB Always On"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Current mode: $CURRENT_LABEL"
echo ""
echo "  Select new mode:"
echo "  Vol ▲  →  Wireless ADB only"
echo "  Vol ▼  →  USB ADB + MTP only"
echo "  (none) →  Both (default)"
echo ""

# 5-second countdown via backgrounded getevent
KEY="both"
GETEVENT_OUT="$(mktemp /data/local/tmp/ge_out.XXXXXX 2>/dev/null || echo /data/local/tmp/ge_out)"

/system/bin/getevent -lqc 1 > "$GETEVENT_OUT" 2>/dev/null &
GE_PID=$!

COUNT=5
while [ $COUNT -gt 0 ]; do
    echo "  Press now... $COUNT"
    sleep 1
    COUNT=$((COUNT - 1))
    if ! kill -0 $GE_PID 2>/dev/null; then
        break
    fi
done

kill $GE_PID 2>/dev/null
wait $GE_PID 2>/dev/null

if grep -q "KEY_VOLUMEUP" "$GETEVENT_OUT" 2>/dev/null; then
    KEY="up"
elif grep -q "KEY_VOLUMEDOWN" "$GETEVENT_OUT" 2>/dev/null; then
    KEY="down"
fi

rm -f "$GETEVENT_OUT"

# Map key to mode
case "$KEY" in
    up)   NEW_MODE="wireless" ; NEW_LABEL="Wireless ADB only"            ;;
    down) NEW_MODE="usb"      ; NEW_LABEL="USB ADB + MTP only"           ;;
    *)    NEW_MODE="both"     ; NEW_LABEL="Wireless ADB + USB ADB + MTP" ;;
esac

# Save
echo "$NEW_MODE" > "$CONF_FILE"

echo ""
echo "  ✓ Mode set: $NEW_LABEL"
echo ""

echo "  Reboot your device to apply the new mode."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
