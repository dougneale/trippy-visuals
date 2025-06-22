#!/bin/bash

# Start HTTP server for testing visualizations
# Usage: ./start-server.sh [port]

PORT=${1:-8000}
PID_FILE=".server.pid"

# Check if server is already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "Server is already running on port $PORT (PID: $PID)"
        echo "URLs available:"
        echo "  http://localhost:$PORT/index.html (main visualization)"
        echo "  http://localhost:$PORT/debug.html (debug version)"
        exit 0
    else
        # Clean up stale PID file
        rm "$PID_FILE"
    fi
fi

# Check if port is in use by another process
EXISTING_PID=$(lsof -ti:$PORT 2>/dev/null | head -1)
if [ ! -z "$EXISTING_PID" ]; then
    echo "⚠️  Port $PORT is already in use by process $EXISTING_PID"
    echo "Attempting to stop the existing process..."
    kill $EXISTING_PID 2>/dev/null
    sleep 2
    
    # Check if it's still running
    if lsof -ti:$PORT > /dev/null 2>&1; then
        echo "❌ Could not free port $PORT. Try a different port:"
        echo "   ./start-server.sh 3000"
        exit 1
    else
        echo "✅ Port $PORT is now available"
    fi
fi

echo "Starting HTTP server on port $PORT..."

# Start server in background
python3 -m http.server $PORT > server.log 2>&1 &
SERVER_PID=$!

# Save PID
echo $SERVER_PID > "$PID_FILE"

# Wait a moment for server to start
sleep 1

# Test if server started successfully
if ps -p $SERVER_PID > /dev/null 2>&1; then
    echo "✅ Server started successfully (PID: $SERVER_PID)"
    echo "📁 Server log: server.log"
    echo ""
    echo "URLs available:"
    echo "  http://localhost:$PORT/index.html (main visualization)"
    echo "  http://localhost:$PORT/debug.html (debug version)"
    echo ""
    echo "To test without opening browser: ./test-pages.sh"
    echo "To stop server: ./stop-server.sh"
else
    echo "❌ Failed to start server"
    exit 1
fi 