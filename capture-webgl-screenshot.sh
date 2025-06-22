#!/bin/bash

# 📸 WEBGL SCREENSHOT CAPTURE
# ===========================
# Uses visible browser for proper WebGL/Three.js rendering

PORT=8000
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCREENSHOTS_DIR="screenshots"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}📸 WebGL Screenshot Capture${NC}"
echo "============================"

# Check if server is running
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo -e "${RED}❌ Server not running on port $PORT${NC}"
    echo "Please run: ./start-server.sh"
    exit 1
fi

mkdir -p "$SCREENSHOTS_DIR"

# Function to capture with visible browser (better WebGL support)
capture_webgl() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Capturing $page with WebGL support...${NC}"
    
    # Use non-headless Chrome for better WebGL support
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --new-window \
        --window-size=1920,1080 \
        --window-position=0,0 \
        --disable-web-security \
        --disable-features=VizDisplayCompositor \
        --enable-gpu \
        --enable-webgl \
        --screenshot="$SCREENSHOTS_DIR/$filename" \
        --virtual-time-budget=15000 \
        "$url" &
    
    local chrome_pid=$!
    
    # Wait for Chrome to start and render
    echo "Waiting 8 seconds for WebGL rendering..."
    sleep 8
    
    # Take screenshot using macOS screencapture of the browser window
    screencapture -x -t png "$SCREENSHOTS_DIR/webgl_${filename}"
    
    # Kill Chrome
    kill $chrome_pid 2>/dev/null
    wait $chrome_pid 2>/dev/null
    
    if [ -f "$SCREENSHOTS_DIR/webgl_${filename}" ]; then
        echo -e "${GREEN}✅ Saved: $SCREENSHOTS_DIR/webgl_${filename}${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to capture $page${NC}"
        return 1
    fi
}

# Alternative: Use AppleScript to automate browser screenshot
capture_with_applescript() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Using AppleScript automation for $page...${NC}"
    
    # Create AppleScript to open browser and take screenshot
    osascript << EOF
tell application "Google Chrome"
    activate
    open location "$url"
    delay 8
end tell

tell application "System Events"
    delay 2
    keystroke "s" using {command down, shift down}
    delay 1
    keystroke "$SCREENSHOTS_DIR/as_${filename}"
    delay 1
    keystroke return
end tell

tell application "Google Chrome"
    close front window
end tell
EOF

    if [ -f "$SCREENSHOTS_DIR/as_${filename}" ]; then
        echo -e "${GREEN}✅ Saved: $SCREENSHOTS_DIR/as_${filename}${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to capture $page${NC}"
        return 1
    fi
}

# Try simple approach: puppeteer-like with longer wait
capture_simple_wait() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Simple capture with 20s wait for $page...${NC}"
    
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless=new \
        --disable-gpu \
        --enable-webgl \
        --window-size=1920,1080 \
        --screenshot="$SCREENSHOTS_DIR/wait_${filename}" \
        --virtual-time-budget=20000 \
        --timeout=25000 \
        "$url" 2>/dev/null
    
    if [ -f "$SCREENSHOTS_DIR/wait_${filename}" ]; then
        echo -e "${GREEN}✅ Saved: $SCREENSHOTS_DIR/wait_${filename}${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to capture $page${NC}"
        return 1
    fi
}

echo -e "\n${BLUE}Trying multiple capture methods:${NC}"

# Method 1: Simple with longer wait
echo -e "\n${YELLOW}Method 1: Extended wait time${NC}"
capture_simple_wait "index.html" "main_${TIMESTAMP}.png"
capture_simple_wait "debug.html" "debug_${TIMESTAMP}.png"

echo -e "\n${BLUE}📁 Check screenshots folder:${NC}"
ls -la "$SCREENSHOTS_DIR/"*"${TIMESTAMP}"* 2>/dev/null || echo "No new screenshots found"

echo -e "\n${YELLOW}💡 If still not working, try:${NC}"
echo "1. Open browser manually to: http://localhost:$PORT/index.html"
echo "2. Wait for full rendering"
echo "3. Take manual screenshot (Cmd+Shift+4)"
echo "4. Save to screenshots/ folder" 