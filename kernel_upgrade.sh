#!/bin/bash
# Script to update GRUB after kernel upgrade on RHEL
# 1. Detect boot mode
# 2. Verify/initramfs (dracut -f if missing)
# 3. grub2-mkconfig -o <correct path>
# 4. grub2-set-default 0
# 5. reboot
# 6. uname -r (verify kernel = latest)

# Detect boot mode
if [ -d /sys/firmware/efi ]; then
    BOOT_MODE="UEFI"
    GRUB_CFG="/boot/efi/EFI/redhat/grub.cfg"
else
    BOOT_MODE="BIOS"
    GRUB_CFG="/boot/grub2/grub.cfg"
fi

echo "System boot mode: $BOOT_MODE"
echo "GRUB configuration path: $GRUB_CFG"

# Find latest installed kernel
LATEST_KERNEL=$(rpm -q kernel | sort -V | tail -1)
KERNEL_VERSION="${LATEST_KERNEL#kernel-}"
INITRAMFS="/boot/initramfs-${KERNEL_VERSION}.img"

echo "Latest kernel detected: $KERNEL_VERSION"

# Step 1: Verify initramfs
if [ ! -f "$INITRAMFS" ]; then
    echo "Initramfs missing for $KERNEL_VERSION, regenerating..."
    dracut -f "$INITRAMFS" "$KERNEL_VERSION"
else
    echo "Initramfs exists: $INITRAMFS"
fi

# Step 2: Update GRUB configuration
echo "Rebuilding GRUB configuration..."
grub2-mkconfig -o "$GRUB_CFG"

# Step 3: Set default kernel (first entry)
echo "Setting latest kernel as default..."
grub2-set-default 0

echo "Kernel upgrade process complete. Please reboot and verify with 'uname -r'."


#################################################################################
## Manual Troubleshooting #######################################################
#uname -r
#ls /boot/vmlinuz-*
#rpm -q kernel
#rpm -q kernel | sort -V
#rpm -q kernel | sort -V | tail -1
#sudo grubby --default-kernel
#sudo grubby --default-kernel --info=ALL
#sudo grubby --default-index
#sudo grubby --info=ALL

#cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
#ls -lh /boot/initramfs-$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}" kernel | sort -V | tail -1).img
#sudo lsinitrd /boot/initramfs-$(uname -r).img
#zcat /boot/initramfs-$(uname -r).img | cpio -t
#LATEST_KERNEL=$(rpm -q kernel | sort -V | tail -1)
#KERNEL_VERSION=${LATEST_KERNEL#kernel-}
#sudo dracut -f /boot/initramfs-${KERNEL_VERSION}.img ${KERNEL_VERSION}
#ls -lh /boot/initramfs-${KERNEL_VERSION}.img

#FOR BIOS
#sudo ls -l /boot/grub2/grub.cfg
#test -r /boot/grub2/grub.cfg && echo "Readable" || echo "Not readable"
#sudo more /boot/grub2/grub.cfg
#grep "menuentry" /boot/grub2/grub.cfg
#awk -F\' '/menuentry / {print $2}' /boot/grub2/grub.cfg
#sudo grub2-mkconfig -o /boot/grub2/grub.cfg
#sudo grub2-reboot 'Red Hat Enterprise Linux (6.8.0-72.el10.x86_64)'
#sudo grub2-set-default 'Red Hat Enterprise Linux (6.8.0-72.el10.x86_64)'
#sudo grub2-set-default 0
#sudo grub2-editenv list

#OR FOR UEFI
#[ -f /boot/grub2/grub.cfg ] && echo "GRUB config exists - BIOS Boot Mode" || echo "Missing GRUB config - Please check EFI"
#[ -d /sys/firmware/efi ] && echo "UEFI mode" || echo "BIOS mode"
#sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
#awk -F\' '/menuentry / {print $2}' /boot/efi/EFI/redhat/grub.cfg
#sudo grub2-reboot 'Red Hat Enterprise Linux (6.8.0-72.el10.x86_64)' 
#sudo grub2-set-default 'Red Hat Enterprise Linux (6.8.0-72.el10.x86_64)'
#sudo grub2-set-default 0
#sudo grubby --set-default-index 0

#sudo grubby --set-default /boot/vmlinuz-6.8.0-72.el10.x86_64
#sudo grub2-editenv list

#reboot
#uname -r
#sudo grubby --default-kernel
#sudo grubby --default-kernel --info=ALL
#sudo grubby --default-index
#sudo grubby --info=ALL
## Manual Troubleshooting #######################################################




