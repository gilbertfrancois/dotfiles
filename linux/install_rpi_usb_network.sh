#!/usr/bin/env bash

cd /boot

# check if the string "dtoverlay=dwc2" in config.txt exists.
if grep -q "dtoverlay=dwc2" config.txt; then
	echo "dwc2 overlay is already enabled"
else
	echo "dtoverlay=dwc2,g_ether" >>config.txt
	echo "dwc2 overlay enabled"
fi

# check if the string "modules-load=dwc2" in cmdline.txt exists.
# if not, append it after "rootwait"
if grep -q "modules-load=dwc2" cmdline.txt; then
	echo "dwc2 module is already loaded"
else
	sed -i 's/rootwait/rootwait modules-load=dwc2/' cmdline.txt
	echo "dwc2 module loaded"
fi

# Add the following file in /etc/network/interfaces.d/usb0

touch /etc/network/interfaces.d/usb0
echo "auto usb0" >>/etc/network/interfaces.d/usb0
echo "allow-hotplug usb0" >>/etc/network/interfaces.d/usb0
echo "iface usb0 inet static" >>/etc/network/interfaces.d/usb0
echo "  address 10.55.0.1" >>/etc/network/interfaces.d/usb0
echo "  netmask 255.255.255.248" >>/etc/network/interfaces.d/usb0
