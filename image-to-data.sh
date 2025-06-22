#!/bin/bash

# 🎨 IMAGE TO TEXT ANALYSIS
# =========================
# Converts image data to readable text analysis

SCREENSHOTS_DIR="screenshots"
LATEST_MAIN=$(ls -t "$SCREENSHOTS_DIR"/main_*.png 2>/dev/null | head -n1)

if [ -z "$LATEST_MAIN" ]; then
    echo "No screenshots found. Run: ./capture-screenshot.sh"
    exit 1
fi

echo "🎨 Visual Analysis of: $LATEST_MAIN"
echo "=================================="

# Basic image properties
echo "📊 Technical Properties:"
sips -g pixelWidth -g pixelHeight -g bitsPerSample -g hasAlpha "$LATEST_MAIN" | grep -E "(pixel|bits|hasAlpha)"

# File size analysis
echo -e "\n📁 File Analysis:"
ls -lh "$LATEST_MAIN" | awk '{print "Size: " $5}'
echo "Compression: $(echo "scale=2; $(stat -f%z "$LATEST_MAIN") / (3840 * 2160 * 3)" | bc) bytes per pixel"

# Try to get color histogram if available
echo -e "\n🌈 Attempting Color Analysis:"
if command -v magick >/dev/null 2>&1; then
    echo "ImageMagick available - generating color histogram..."
    magick "$LATEST_MAIN" -format "%c" histogram:info: | head -10
elif command -v convert >/dev/null 2>&1; then
    echo "ImageMagick convert available..."
    convert "$LATEST_MAIN" -format "%c" histogram:info: | head -10
else
    echo "ImageMagick not available for color analysis"
    echo "Consider installing: brew install imagemagick"
fi

echo -e "\n💡 For AI Analysis:"
echo "File exists: $([ -f "$LATEST_MAIN" ] && echo "✅ Yes" || echo "❌ No")"
echo "Readable: $([ -r "$LATEST_MAIN" ] && echo "✅ Yes" || echo "❌ No")"
echo "Path: $LATEST_MAIN" 