#!/system/bin/sh

# Wait for the package manager to be fully ready
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Give it a few extra seconds for package scan to finish
sleep 5

# Remove DocumentsUI as role holder and set Material Files
cmd role remove-role-holder android.app.role.FILE_MANAGER com.google.android.documentsui 0
cmd role add-role-holder android.app.role.FILE_MANAGER me.zhanghai.android.files 0

# Clear any cached preferred activities that might trigger the chooser
pm clear-package-preferred-activities com.google.android.documentsui 2>/dev/null || true