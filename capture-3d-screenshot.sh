#!/bin/bash

# 📸 3D VISUALIZATION SCREENSHOT CAPTURE
# ======================================
# Enhanced screenshot capture for Three.js visualizations
# Waits for proper 3D rendering before capturing

PORT=8000
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCREENSHOTS_DIR="screenshots"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 3D Visualization Screenshot Capture${NC}"
echo "======================================"

# Check if server is running
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo -e "${RED}❌ Server not running on port $PORT${NC}"
    echo "Please run: ./start-server.sh"
    exit 1
fi

# Ensure screenshots directory exists
mkdir -p "$SCREENSHOTS_DIR"

# Function to capture 3D screenshot with proper waiting
capture_3d_page() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Capturing $page (waiting for 3D rendering)...${NC}"
    
    # Create a temporary HTML file that waits for rendering
    local temp_html="/tmp/screenshot_waiter_${TIMESTAMP}.html"
    cat > "$temp_html" << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { margin: 0; background: #000; }
        #status { 
            position: fixed; 
            top: 10px; 
            left: 10px; 
            color: white; 
            font-family: Arial; 
            z-index: 9999;
            background: rgba(0,0,0,0.8);
            padding: 5px;
        }
    </style>
</head>
<body>
    <div id="status">Loading 3D scene...</div>
    <iframe src="$url" width="100%" height="100%" frameborder="0"></iframe>
    
    <script>
        // Wait for iframe to load, then wait additional time for 3D rendering
        setTimeout(() => {
            document.getElementById('status').textContent = '3D Scene Ready';
            document.title = 'READY_FOR_SCREENSHOT';
        }, 6000); // 6 seconds for 3D initialization
    </script>
</body>
</html>
EOF
    
    # Use Chrome with the wrapper HTML
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless \
        --disable-gpu \
        --disable-web-security \
        --disable-background-timer-throttling \
        --window-size=1920,1080 \
        --screenshot="$SCREENSHOTS_DIR/$filename" \
        --virtual-time-budget=10000 \
        --run-all-compositor-stages-before-draw \
        "file://$temp_html" 2>/dev/null
    
    # Clean up temp file
    rm -f "$temp_html"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Saved: $SCREENSHOTS_DIR/$filename${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to capture $page${NC}"
        return 1
    fi
}

# Alternative: Direct capture with longer wait
capture_direct_3d() {
    local page=$1
    local filename=$2
    local url="http://localhost:$PORT/$page"
    
    echo -e "${YELLOW}📷 Direct capture of $page (10s wait)...${NC}"
    
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --headless \
        --disable-gpu \
        --disable-web-security \
        --disable-background-timer-throttling \
        --disable-backgrounding-occluded-windows \
        --disable-renderer-backgrounding \
        --window-size=1920,1080 \
        --screenshot="$SCREENSHOTS_DIR/$filename" \
        --virtual-time-budget=12000 \
        --run-all-compositor-stages-before-draw \
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
echo -e "\n${BLUE}Main 3D Visualization:${NC}"
if capture_direct_3d "index.html" "3d_main_${TIMESTAMP}.png"; then
    MAIN_CAPTURED=true
fi

# Capture debug version
echo -e "\n${BLUE}Debug 3D Version:${NC}"
if capture_direct_3d "debug.html" "3d_debug_${TIMESTAMP}.png"; then
    DEBUG_CAPTURED=true
fi

# Summary
echo -e "\n${BLUE}📊 3D Capture Summary:${NC}"
echo "======================"
echo "Timestamp: $TIMESTAMP"

if [ "$MAIN_CAPTURED" = true ]; then
    echo -e "${GREEN}✅ Main 3D visualization captured${NC}"
fi

if [ "$DEBUG_CAPTURED" = true ]; then
    echo -e "${GREEN}✅ Debug 3D version captured${NC}"
fi

echo -e "\n${BLUE}📁 Screenshots saved in:${NC} $SCREENSHOTS_DIR/"
ls -la "$SCREENSHOTS_DIR/"*3d*"${TIMESTAMP}"* 2>/dev/null | while read -r line; do
    echo "  $line"
done

echo -e "\n${YELLOW}💡 Usage:${NC}"
echo "  Latest 3D main: open $SCREENSHOTS_DIR/3d_main_${TIMESTAMP}.png"
echo "  Latest 3D debug: open $SCREENSHOTS_DIR/3d_debug_${TIMESTAMP}.png"

# Optional: Auto-open latest screenshot
if [ "$1" = "--open" ]; then
    if [ "$MAIN_CAPTURED" = true ]; then
        echo -e "\n${BLUE}🖼️  Opening latest 3D screenshot...${NC}"
        open "$SCREENSHOTS_DIR/3d_main_${TIMESTAMP}.png"
    fi
fi 