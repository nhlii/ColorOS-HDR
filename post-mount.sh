#!/system/bin/sh
MODDIR=${0%/*}

# OverlayFS参数设置
LOWER_CHU="/my_product/vendor/etc"     # 下层目录
UPPER_CHU="$MODDIR/my_product/vendor/etc"  # 上层目录
WORK_CHU="$MODDIR/work"  # 临时工作目录
TARGET_CHU="/my_product/vendor/etc"    # 挂载点

# 等待 /my_product 挂载
timeout=30
while [ $timeout -gt 0 ] && [ ! -d "/my_product" ]; do
  sleep 1
  timeout=$((timeout - 1))
done
if [ ! -d "/my_product" ]; then
  echo "Error: /my_product not mounted!"
  exit 1
fi

# 等待子目录 /vendor/etc 就绪
timeout=30
while [ $timeout -gt 0 ] && [ ! -d "$LOWER_CHU" ]; do
  sleep 1
  timeout=$((timeout - 1))
done
if [ ! -d "$LOWER_CHU" ]; then
  echo "Error: $LOWER_CHU not found!"
  exit 1
fi

# 检查是否已挂载
if mount | grep -q "$TARGET_CHU.*overlay"; then
  umount -l "$TARGET_CHU"
fi

# 确保work环境
rm -rf "$WORK_CHU" && mkdir -p "$WORK_CHU"

# 挂载OverlayFS
mount -t overlay overlay -o lowerdir="$LOWER_CHU",upperdir="$UPPER_CHU",workdir="$WORK_CHU" "$TARGET_CHU"
