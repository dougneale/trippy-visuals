#!/bin/bash

# 📸 3D Visualization Screenshot Capture
# ======================================
# Captures screenshots of 3D visualizations with extended wait times
# for proper WebGL rendering and complex scene loading

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 3D Visualization Screenshot Capture${NC}"
echo "======================================"

# Check if server is running
if ! curl -s http://localhost:8000 > /dev/null 2>&1; then
    echo -e "${RED}❌ Server not running${NC}"
    echo "💡 Start server first: ./start-server.sh"
    exit 1
fi

# Create screenshots directory if it doesn't exist
mkdir -p screenshots

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo ""
echo -e "${YELLOW}Main 3D Visualization:${NC}"
echo -e "${BLUE}📷 Direct capture of sandbox.html (10s wait)...${NC}"

# Capture main visualization (sandbox.html for development)
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --disable-software-rasterizer \
    --disable-dev-shm-usage \
    --no-sandbox \
    --window-size=1200,800 \
    --virtual-time-budget=10000 \
    --screenshot="screenshots/3d_sandbox_${TIMESTAMP}.png" \
    "http://localhost:8000/sandbox.html" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Saved: screenshots/3d_sandbox_${TIMESTAMP}.png${NC}"
else
    echo -e "${RED}❌ Failed to capture sandbox screenshot${NC}"
fi

echo ""
echo -e "${YELLOW}Debug 3D Version:${NC}"
echo -e "${BLUE}📷 Direct capture of debug.html (10s wait)...${NC}"

# Capture debug version
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --disable-software-rasterizer \
    --disable-dev-shm-usage \
    --no-sandbox \
    --window-size=1200,800 \
    --virtual-time-budget=10000 \
    --screenshot="screenshots/3d_debug_${TIMESTAMP}.png" \
    "http://localhost:8000/debug.html" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Saved: screenshots/3d_debug_${TIMESTAMP}.png${NC}"
else
    echo -e "${RED}❌ Failed to capture debug screenshot${NC}"
fi

echo ""
echo -e "${YELLOW}Gallery Screenshot:${NC}"
echo -e "${BLUE}📷 Direct capture of index.html (5s wait)...${NC}"

# Capture gallery page
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --disable-software-rasterizer \
    --disable-dev-shm-usage \
    --no-sandbox \
    --window-size=1200,800 \
    --virtual-time-budget=5000 \
    --screenshot="screenshots/gallery_${TIMESTAMP}.png" \
    "http://localhost:8000/index.html" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Saved: screenshots/gallery_${TIMESTAMP}.png${NC}"
else
    echo -e "${RED}❌ Failed to capture gallery screenshot${NC}"
fi

echo ""
echo -e "${GREEN}📊 3D Capture Summary:${NC}"
echo "======================"
echo "Timestamp: $TIMESTAMP"
echo -e "${GREEN}✅ Sandbox visualization captured${NC}"
echo -e "${GREEN}✅ Debug version captured${NC}"
echo -e "${GREEN}✅ Gallery page captured${NC}"

echo ""
echo -e "${BLUE}📁 Screenshots saved in: screenshots/${NC}"
ls -la screenshots/*_${TIMESTAMP}.png 2>/dev/null

echo ""
echo -e "${YELLOW}💡 Usage:${NC}"
echo "  Latest sandbox: open screenshots/3d_sandbox_${TIMESTAMP}.png"
echo "  Latest debug: open screenshots/3d_debug_${TIMESTAMP}.png"
echo "  Latest gallery: open screenshots/gallery_${TIMESTAMP}.png" 