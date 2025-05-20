#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
MERGER="/system/my_product/vendor/etc"    # 挂载点
LOWER="/system/my_product/vendor/etc"     # 下级目录
UPPER="$MODDIR/system/my_product/vendor/etc"  # 上级目录
WORK="$MODDIR/work"  # 临时工作目录

# 创建必要目录
mkdir -p "$MERGER" "$UPPER" "$WORK"

# 挂载OverlayFS
mount -t overlay KSU -o lowerdir="$LOWER",upperdir="$UPPER",workdir="$WORK" "$MERGER"
