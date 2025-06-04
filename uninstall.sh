#!/system/bin/sh
MODDIR=${0%/*}

TARGET_CHU="/my_product/vendor/etc"
umount -l "$TARGET_CHU"  # 强制卸载
rm -rf "$MODDIR/work"    # 清理工作目录