#!/system/bin/sh
# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Set USB mode to MTP + ADB
setprop sys.usb.config mtp,adb
setprop sys.usb.state mtp,adb

# Enable ADB over TCP
setprop service.adb.tcp.port 5555
stop adbd
start adbd
