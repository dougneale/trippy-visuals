#!/bin/bash

# 📸 AUTOMATED SCREENSHOT CAPTURE
# ================================
# Captures the current state of visualizations for AI analysis

PORT=8000
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCREENSHOTS_DIR="screenshots"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 Automated Screenshot Capture${NC}"
echo "=================================="

# Check if server is running
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo -e "${RED}❌ Server not running on port $PORT${NC}"
    echo "Please run: ./start-server.sh"
    exit 1
fi

# Ensure screenshots directory exists
mkdir -p "$SCREENSHOTS_DIR"

# Function to capture screenshot
capture_page() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Capturing $page...${NC}"
    
    # Use Chrome in headless mode to capture screenshot
    # Increased wait time for Three.js initialization and rendering
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless \
        --disable-gpu \
        --disable-web-security \
        --window-size=1920,1080 \
        --screenshot="$SCREENSHOTS_DIR/$filename" \
        --virtual-time-budget=8000 \
        --run-all-compositor-stages-before-draw \
        --disable-background-timer-throttling \
        "$url" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Saved: $SCREENSHOTS_DIR/$filename${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to capture $page${NC}"
        return 1
    fi
}

# Capture main visualization
echo -e "\n${BLUE}Main Visualization:${NC}"
if capture_page "index.html" "main_${TIMESTAMP}.png"; then
    MAIN_CAPTURED=true
fi

# Capture debug version
echo -e "\n${BLUE}Debug Version:${NC}"
if capture_page "debug.html" "debug_${TIMESTAMP}.png"; then
    DEBUG_CAPTURED=true
fi

# Summary
echo -e "\n${BLUE}📊 Capture Summary:${NC}"
echo "==================="
echo "Timestamp: $TIMESTAMP"

if [ "$MAIN_CAPTURED" = true ]; then
    echo -e "${GREEN}✅ Main visualization captured${NC}"
fi

if [ "$DEBUG_CAPTURED" = true ]; then
    echo -e "${GREEN}✅ Debug version captured${NC}"
fi

echo -e "\n${BLUE}📁 Screenshots saved in:${NC} $SCREENSHOTS_DIR/"
ls -la "$SCREENSHOTS_DIR/" | tail -n +2 | while read -r line; do
    echo "  $line"
done

echo -e "\n${YELLOW}💡 Usage:${NC}"
echo "  View screenshots: open $SCREENSHOTS_DIR/"
echo "  Latest main: open $SCREENSHOTS_DIR/main_${TIMESTAMP}.png"
echo "  Latest debug: open $SCREENSHOTS_DIR/debug_${TIMESTAMP}.png"

# Optional: Auto-open latest screenshot
if [ "$1" = "--open" ]; then
    if [ "$MAIN_CAPTURED" = true ]; then
        echo -e "\n${BLUE}🖼️  Opening latest screenshot...${NC}"
        open "$SCREENSHOTS_DIR/main_${TIMESTAMP}.png"
    fi
fi 