#!/bin/sh

[ "$1" = "post" ] && exec /usr/sbin/modprobe ath11k_pci ath11k 
[ "$1" = "pre" ] && exec /usr/sbin/rmmod ath11k_pci ath11k 

exit 0

