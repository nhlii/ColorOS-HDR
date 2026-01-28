#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
LOWER_CHU="/my_product/vendor/etc"     # 下层目录
TARGET_CHU="$LOWER_CHU"    # 挂载点
UPPER_CHU="$MODDIR/overlay/upper"  # 上层目录
WORK_CHU="$MODDIR/overlay/work"  # 临时工作目录

# 确保work环境
mkdir -p "$UPPER_CHU" "$WORK_CHU"
rm -rf "$WORK_CHU"/*
rm -rf "$WORK_CHU"/.[!.]* "$WORK_CHU"/..?* 2>/dev/null

# 确保目标文件权限
[ -f "$UPPER_CHU/$NAME" ] || exit 1
chmod 0644 "$UPPER_CHU/$NAME"
chown 0:0 "$UPPER_CHU/$NAME"

# 挂载OverlayFS
mount -t overlay overlay -o lowerdir="$LOWER_CHU",upperdir="$UPPER_CHU",workdir="$WORK_CHU" "$TARGET_CHU"
