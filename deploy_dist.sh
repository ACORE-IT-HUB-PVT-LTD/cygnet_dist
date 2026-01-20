#!/bin/bash
set -e

# ---------- CONFIG ----------
WORK_DIR="/home/ubuntu/cygnet_dist"
TARGET_DIR="/var/www/yaatrabuddy-frontend"
ZIP_PATTERN="dist*.zip"
# ----------------------------

echo "🚀 Starting frontend dist deployment..."

cd "$WORK_DIR"

echo "🔍 Detecting latest dist zip..."
LATEST_ZIP=$(ls -t $ZIP_PATTERN 2>/dev/null | head -n 1)

if [ -z "$LATEST_ZIP" ]; then
  echo "❌ No dist zip found in $WORK_DIR"
  exit 1
fi

echo "✅ Using $LATEST_ZIP"

echo "📦 Backing up old frontend..."
if [ -d "$TARGET_DIR" ]; then
  sudo mv "$TARGET_DIR" "${TARGET_DIR}_backup_$(date +%F_%H-%M-%S)"
fi

echo "📦 Creating fresh target directory..."
sudo mkdir -p "$TARGET_DIR"

echo "📦 Extracting zip directly into target..."
sudo unzip -o "$LATEST_ZIP" -d "$TARGET_DIR"

if [ ! -f "$TARGET_DIR/index.html" ]; then
  echo "❌ index.html not found after unzip"
  exit 1
fi

echo "🔐 Fixing ownership & permissions..."
sudo chown -R www-data:www-data "$TARGET_DIR"
sudo chmod -R 775 "$TARGET_DIR"

echo "✅ Frontend deployment completed successfully!"

