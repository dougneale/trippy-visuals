#!/bin/bash

# 🌐 Browser Control Script
# ========================
# Opens specific pages in the browser for testing and development

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌐 Browser Control Script${NC}"
echo "=========================="

# Check if server is running
if ! curl -s http://localhost:8000 > /dev/null 2>&1; then
    echo -e "${RED}❌ Server not running${NC}"
    echo "💡 Start server first: ./start-server.sh"
    exit 1
fi

# Parse command line arguments
PAGE=${1:-"gallery"}

case $PAGE in
    "gallery" | "index")
        echo -e "${GREEN}🏛️ Opening Gallery (index.html)${NC}"
        open "http://localhost:8000/index.html"
        ;;
    "sandbox" | "dev")
        echo -e "${YELLOW}🛠️ Opening Development Sandbox${NC}"
        open "http://localhost:8000/sandbox.html"
        ;;
    "debug")
        echo -e "${BLUE}🐛 Opening Debug Mode${NC}"
        open "http://localhost:8000/debug.html"
        ;;
    "both")
        echo -e "${GREEN}🏛️ Opening Gallery${NC}"
        open "http://localhost:8000/index.html"
        sleep 1
        echo -e "${YELLOW}🛠️ Opening Sandbox${NC}"
        open "http://localhost:8000/sandbox.html"
        ;;
    "all")
        echo -e "${GREEN}🏛️ Opening Gallery${NC}"
        open "http://localhost:8000/index.html"
        sleep 1
        echo -e "${YELLOW}🛠️ Opening Sandbox${NC}"
        open "http://localhost:8000/sandbox.html"
        sleep 1
        echo -e "${BLUE}🐛 Opening Debug${NC}"
        open "http://localhost:8000/debug.html"
        ;;
    *)
        echo -e "${RED}❌ Unknown page: $PAGE${NC}"
        echo ""
        echo "📖 Available options:"
        echo "  gallery (default) - Main gallery/portfolio page"
        echo "  sandbox          - Development workspace"
        echo "  debug           - Debug/testing page"
        echo "  both            - Gallery + Sandbox"
        echo "  all             - Gallery + Sandbox + Debug"
        echo ""
        echo "💡 Usage examples:"
        echo "  ./open-browser.sh gallery"
        echo "  ./open-browser.sh sandbox"
        echo "  ./open-browser.sh both"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Browser opened successfully${NC}" 