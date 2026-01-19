#!/bin/bash
set -e

# ---------- CONFIG ----------
WORK_DIR="/home/ubuntu/cygnet_backend/dist"
TARGET_DIR="/var/www/yaatrabuddy-frontend"
ZIP_PATTERN="dist*.zip"
TMP_DIR="/tmp/frontend_dist"
# ----------------------------

echo "🚀 Starting frontend dist deployment..."

cd "$WORK_DIR"

echo "🔍 Detecting latest dist zip..."
LATEST_ZIP=$(ls -t $ZIP_PATTERN 2>/dev/null | head -n 1)

if [ -z "$LATEST_ZIP" ]; then
  echo "❌ No dist zip found"
  exit 1
fi

echo "✅ Using $LATEST_ZIP"

echo "🧹 Preparing temp directory..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "📦 Extracting zip..."
unzip -o "$LATEST_ZIP" -d "$TMP_DIR"

if [ ! -f "$TMP_DIR/index.html" ]; then
  echo "❌ index.html not found after unzip"
  exit 1
fi

echo "📦 Backing up old frontend..."
if [ -d "$TARGET_DIR" ]; then
  sudo mv "$TARGET_DIR" "${TARGET_DIR}_backup_$(date +%F_%H-%M-%S)"
fi

echo "🚚 Deploying new frontend..."
sudo mkdir -p "$TARGET_DIR"
sudo cp -r "$TMP_DIR"/* "$TARGET_DIR/"

echo "🔐 Fixing ownership & permissions..."
sudo chown -R www-data:www-data "$TARGET_DIR"
sudo chmod -R 775 "$TARGET_DIR"

echo "🧹 Cleaning temp files..."
rm -rf "$TMP_DIR"

echo "✅ Frontend deployment completed!"
