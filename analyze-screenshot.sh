#!/bin/bash

# 🔍 SCREENSHOT ANALYSIS
# ======================
# Provides analysis of captured screenshots for AI feedback

SCREENSHOTS_DIR="screenshots"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔍 Screenshot Analysis${NC}"
echo "======================"

# Find latest screenshots
LATEST_MAIN=$(ls -t "$SCREENSHOTS_DIR"/main_*.png 2>/dev/null | head -n1)
LATEST_DEBUG=$(ls -t "$SCREENSHOTS_DIR"/debug_*.png 2>/dev/null | head -n1)

if [ -z "$LATEST_MAIN" ]; then
    echo -e "${YELLOW}No screenshots found. Run: ./capture-screenshot.sh${NC}"
    exit 1
fi

echo -e "\n${GREEN}📸 Latest Screenshots:${NC}"
echo "Main: $LATEST_MAIN"
echo "Debug: $LATEST_DEBUG"

# Get image info using sips (macOS built-in)
if command -v sips >/dev/null 2>&1; then
    echo -e "\n${BLUE}🖼️  Main Screenshot Info:${NC}"
    sips -g pixelWidth -g pixelHeight -g format "$LATEST_MAIN" | grep -E "(pixelWidth|pixelHeight|format)"
    
    echo -e "\n${BLUE}📊 File Sizes:${NC}"
    ls -lh "$LATEST_MAIN" | awk '{print "Main: " $5}'
    if [ -n "$LATEST_DEBUG" ]; then
        ls -lh "$LATEST_DEBUG" | awk '{print "Debug: " $5}'
    fi
fi

# Quick visual check by opening
echo -e "\n${YELLOW}💡 Quick Actions:${NC}"
echo "  Open main: open \"$LATEST_MAIN\""
echo "  Open debug: open \"$LATEST_DEBUG\""
echo "  View folder: open \"$SCREENSHOTS_DIR\""

# Auto-open if requested
if [ "$1" = "--open" ]; then
    echo -e "\n${GREEN}🖼️  Opening screenshots...${NC}"
    open "$LATEST_MAIN"
    if [ -n "$LATEST_DEBUG" ]; then
        open "$LATEST_DEBUG"
    fi
fi 