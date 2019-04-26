#!/bin/bash

qemu-system-x86_64 -m 8G -cpu host -enable-kvm -drive format=raw,file=/home/alethenorio/Documents/Windows_10.img -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:2222 -vga std -usb -device usb-tablet &
