#!/bin/bash

# Stop the HTTP server
PID_FILE=".server.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "No server PID file found. Server may not be running."
    exit 1
fi

PID=$(cat "$PID_FILE")

if ps -p $PID > /dev/null 2>&1; then
    echo "Stopping server (PID: $PID)..."
    kill $PID
    
    # Wait for process to stop
    sleep 1
    
    if ps -p $PID > /dev/null 2>&1; then
        echo "Process didn't stop, forcing..."
        kill -9 $PID
    fi
    
    echo "✅ Server stopped"
else
    echo "Server process not found (PID: $PID)"
fi

# Clean up PID file
rm "$PID_FILE"

# Clean up log file
if [ -f "server.log" ]; then
    rm "server.log"
fi 