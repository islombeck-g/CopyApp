#!/bin/bash
# Build CopyStack.app. Usage: ./build.sh [--install]
set -euo pipefail
cd "$(dirname "$0")"

APP="build/CopyStack.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

swiftc -O -swift-version 5 Sources/main.swift -o "$APP/Contents/MacOS/CopyStack"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>CopyStack</string>
    <key>CFBundleDisplayName</key><string>CopyStack</string>
    <key>CFBundleIdentifier</key><string>com.islam.copystack</string>
    <key>CFBundleExecutable</key><string>CopyStack</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
    <key>LSUIElement</key><true/>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

codesign --force --deep -s - "$APP"
echo "Built $APP"

if [[ "${1:-}" == "--install" ]]; then
    pkill -x CopyStack 2>/dev/null || true
    rm -rf /Applications/CopyStack.app
    cp -R "$APP" /Applications/
    echo "Installed /Applications/CopyStack.app"
fi
