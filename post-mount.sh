#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
TARGET="/system/my_product/vendor/etc"    # 要覆盖的目录
LOWER="/system/my_product/vendor/etc"     # 原系统目录
UPPER="$MODDIR/system/my_product/vendor/etc"  # 你的修改文件所在目录
WORK="$MODDIR/system/my_product/vendor/work"  # 临时工作目录

# 创建必要目录
mkdir -p "$TARGET" "$UPPER" "$WORK"

# 挂载OverlayFS（合并原目录和你的修改）
mount -t overlay KSU -o lowerdir="$LOWER",upperdir="$UPPER",workdir="$WORK" "$TARGET"
