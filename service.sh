#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
LOWER_CHU="/my_product/vendor/etc"     # 下层目录
TARGET_CHU="$LOWER_CHU"    # 挂载点
UPPER_CHU="$MODDIR/overlay/upper"  # 上层目录
WORK_CHU="$MODDIR/overlay/work"  # 临时工作目录
NAME="multimedia_display_feature_config.xml"  # 目标文件

# 确保work环境
mkdir -p "$UPPER_CHU" "$WORK_CHU"
rm -rf "$WORK_CHU"/*
rm -rf "$WORK_CHU"/.[!.]* "$WORK_CHU"/..?* 2>/dev/null

# 等待/my_product挂载
timeout=30
while [ $timeout -gt 0 ] && [ ! -f "$LOWER_CHU/$NAME" ]; do
  sleep 1
  timeout=$((timeout - 1))
done
if [ ! -f "$LOWER_CHU/$NAME" ]; then
  echo "Error: lower file not ready: $LOWER_CHU/$NAME"
  exit 1
fi

# 确保upper目标文件存在
if [ ! -f "$UPPER_CHU/$NAME" ]; then
  echo "Error: upper file missing: $UPPER_CHU/$NAME"
  exit 1
fi

# 确保目标文件权限
chmod 0644 "$UPPER_CHU/$NAME"
chown 0:0 "$UPPER_CHU/$NAME"

# 对齐 SELinux label
if command -v chcon >/dev/null 2>&1 && [ -f "$LOWER_CHU/$NAME" ]; then
  chcon --reference="$LOWER_CHU/$NAME" "$UPPER_CHU/$NAME" 2>/dev/null || true
fi

# 检查是否已挂载
if awk -v mp="$TARGET_CHU" '$2==mp {found=1} END{exit !found}' /proc/mounts; then
  umount "$TARGET_CHU" 2>/dev/null || umount -l "$TARGET_CHU" 2>/dev/null || true
fi

# 挂载OverlayFS
mount -t overlay overlay -o lowerdir="$LOWER_CHU",upperdir="$UPPER_CHU",workdir="$WORK_CHU" "$TARGET_CHU"
