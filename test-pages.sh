#!/bin/bash

# Test visualization pages without opening browser
# Usage: ./test-pages.sh [port]

PORT=${1:-8000}
BASE_URL="http://localhost:$PORT"

echo "Testing visualization pages on port $PORT..."
echo

# Test if server is running
if ! curl -s "$BASE_URL" > /dev/null; then
    echo "❌ Server not responding on port $PORT"
    echo "Start server first with: ./start-server.sh"
    exit 1
fi

echo "✅ Server is responding"

# Test main visualization
echo -n "Testing index.html... "
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/index.html")
if [ "$RESPONSE" = "200" ]; then
    echo "✅ OK"
else
    echo "❌ Failed (HTTP $RESPONSE)"
fi

# Test debug version
echo -n "Testing debug.html... "
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/debug.html")
if [ "$RESPONSE" = "200" ]; then
    echo "✅ OK"
else
    echo "❌ Failed (HTTP $RESPONSE)"
fi

# Check for any JavaScript errors by looking at the HTML content
echo -n "Checking for basic HTML structure... "
MAIN_CONTENT=$(curl -s "$BASE_URL/index.html")
if echo "$MAIN_CONTENT" | grep -q "canvas" && echo "$MAIN_CONTENT" | grep -q "WebGL"; then
    echo "✅ HTML structure looks good"
else
    echo "❌ HTML structure issues detected"
fi

echo
echo "📊 Server status:"
echo "  Main visualization: $BASE_URL/index.html"
echo "  Debug version: $BASE_URL/debug.html"
echo
echo "To manually open in browser:"
echo "  open $BASE_URL/index.html"
echo "  open $BASE_URL/debug.html"
echo
echo "To view server logs: tail -f server.log" 