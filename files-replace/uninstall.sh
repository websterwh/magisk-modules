#!/system/bin/sh

# Re-enable the stock DocumentsUIGoogle in case it was disabled
pm enable com.google.android.documentsui 2>/dev/null
pm enable com.google.android.documentsui.DocumentsActivity 2>/dev/null

# Clean up any leftover temp files
rm -f /data/local/tmp/materialfiles-update.apk

echo "DocumentsUIGoogle re-enabled. Reboot to restore."