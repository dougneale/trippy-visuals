#!/bin/bash

# Manually open browser with visualization
# Usage: ./open-browser.sh [page] [port]

PAGE=${1:-index}
PORT=${2:-8000}
BASE_URL="http://localhost:$PORT"

# Validate page option
case $PAGE in
    "index" | "main")
        URL="$BASE_URL/index.html"
        echo "Opening main visualization..."
        ;;
    "debug")
        URL="$BASE_URL/debug.html"
        echo "Opening debug version..."
        ;;
    "both")
        echo "Opening both pages..."
        open "$BASE_URL/index.html"
        sleep 1
        open "$BASE_URL/debug.html"
        exit 0
        ;;
    *)
        echo "Usage: $0 [index|debug|both] [port]"
        echo "  index/main: Open main visualization (default)"
        echo "  debug: Open debug version"
        echo "  both: Open both pages"
        echo "  port: Server port (default: 8000)"
        exit 1
        ;;
esac

# Check if server is running
if ! curl -s "$BASE_URL" > /dev/null 2>&1; then
    echo "❌ Server not responding on port $PORT"
    echo "Start server first with: ./start-server.sh"
    exit 1
fi

# Open the page
open "$URL"
echo "✅ Browser opened: $URL" 