if [ `xrandr | grep -c ' connected '` -eq 2 ];  then
    source ~/.docked.sh
else
    source ~/.undocked.sh
fi

# startup stuffs
displays=($(xrandr | awk '/ connected /{print $1}'))
selected_display="${displays[0]}"

xrandr --output "$selected_display" --brightness 0.75

# power savings
echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';
echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy';
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';
echo 'auto' > '/sys/bus/usb/devices/1-9/power/control';
echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control';
