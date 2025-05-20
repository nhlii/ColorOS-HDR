#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
LOWER_CHU="/system/my_product/vendor/etc"     # 下级目录
UPPER_CHU="$MODDIR/system/my_product/vendor/etc"  # 上级目录
WORK_CHU="$MODDIR/work"  # 临时工作目录
MERGER_CHU="$MODDIR/merged"    # 挂载点

# 创建必要目录
mkdir -p "$UPPER_CHU" "$WORK_CHU" "$MERGER_CHU"

# 挂载OverlayFS
mount -t overlay KSU -o lowerdir="$LOWER_CHU",upperdir="$UPPER_CHU",workdir="$WORK_CHU" "$MERGER_CHU"
