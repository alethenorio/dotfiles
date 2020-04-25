#!/bin/bash

# 1. Download the win-virtio iso with virtio disk drivers for windows 10 at https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html#virtio-win-direct-downloads
# 2. Create qcow2 image qemu-img create -f qcow2 /home/alethenorio/vms/windows_10/disk.qcow2 200G
# 3. Start installation CD
#  qemu-system-x86_64 -m 5G -cpu host -enable-kvm -drive file=/home/alethenorio/Downloads/virtio-win-0.1.171.iso,media=cdrom -drive driver=qcow2,file=/home/alethenorio/vms/windows_10/disk.qcow2,if=virtio -net nic,model=virtio -net user -machine type=pc,accel=kvm -usb -device usb-tablet -vga cirrus -drive format=raw,media=cdrom,readonly,file=/home/alethenorio/Downloads/Win10_1903_V2_English_x64.iso -rtc base=localtime,clock=host -smp cores=4,threads=8

qemu-system-x86_64 -m 6G -cpu host -rtc base=localtime,clock=host -enable-kvm -drive driver=qcow2,file=/home/alethenorio/vms/windows_10/disk.qcow2,if=virtio -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5556-:22 -vga qxl -usb -device usb-tablet -usb -device usb-host,hostbus=1,hostport=1 -usb -device usb-host,hostbus=1,hostport=2 -M q35 &
