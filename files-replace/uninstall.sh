#!/system/bin/sh

# Re-enable the stock DocumentsUIGoogle in case it was disabled
pm enable com.google.android.documentsui 2>/dev/null
pm enable com.google.android.documentsui.DocumentsActivity 2>/dev/null

# Restore role defaults
cmd role remove-role-holder android.app.role.FILE_MANAGER me.zhanghai.android.files 0 2>/dev/null || true
cmd role add-role-holder android.app.role.FILE_MANAGER com.google.android.documentsui 0 2>/dev/null || true

# Clean up any leftover temp files
rm -f /data/local/tmp/materialfiles-update.apk

echo "DocumentsUIGoogle re-enabled. Reboot to restore."