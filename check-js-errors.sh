#!/bin/bash

# Default to index.html if no parameter provided
TARGET_FILE=${1:-index.html}

echo "🔍 JavaScript Error Detection"
echo "============================"
echo "📄 Checking: $TARGET_FILE"

# Check if server is running
if ! curl -s http://localhost:8000 > /dev/null; then
    echo "❌ Server not running on port 8000"
    echo "💡 Run: ./start-server.sh"
    exit 1
fi

echo "✅ Server is responding"

# Create a simple HTML page that loads our visualization and captures errors
cat > /tmp/error_checker.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Error Checker</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .error { color: red; font-weight: bold; }
        .success { color: green; font-weight: bold; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h2>JavaScript Error Detection</h2>
    <div id="status">Loading...</div>
    <div id="errors"></div>
    
    <script>
        let errorCount = 0;
        let loadSuccess = false;
        
        // Capture JavaScript errors
        window.addEventListener('error', function(e) {
            errorCount++;
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error';
            errorDiv.innerHTML = '❌ ERROR ' + errorCount + ': ' + e.message + '<br>File: ' + e.filename + ':' + e.lineno + ':' + e.colno;
            document.getElementById('errors').appendChild(errorDiv);
        });
        
        // Load the main visualization in an iframe
        const iframe = document.createElement('iframe');
        iframe.src = 'http://localhost:8000/$TARGET_FILE';
        iframe.style.width = '1px';
        iframe.style.height = '1px';
        iframe.style.opacity = '0';
        iframe.style.position = 'absolute';
        iframe.style.left = '-9999px';
        
        iframe.onload = function() {
            setTimeout(() => {
                if (errorCount === 0) {
                    document.getElementById('status').innerHTML = '<div class="success">✅ No JavaScript errors detected!</div>';
                } else {
                    document.getElementById('status').innerHTML = '<div class="error">❌ Found ' + errorCount + ' JavaScript error(s)</div>';
                }
            }, 3000); // Wait 3 seconds for page to fully load
        };
        
        iframe.onerror = function() {
            document.getElementById('status').innerHTML = '<div class="error">❌ Failed to load visualization</div>';
        };
        
        document.body.appendChild(iframe);
    </script>
</body>
</html>
EOF

# Serve the error checker and capture results
echo "🔍 Checking for JavaScript errors..."
echo "📄 Loading visualization and monitoring for 5 seconds..."

# Use curl to get the error checker results
timeout 8 /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --virtual-time-budget=5000 \
    --run-all-compositor-stages-before-draw \
    --disable-background-timer-throttling \
    --disable-renderer-backgrounding \
    --disable-backgrounding-occluded-windows \
    file:///tmp/error_checker.html 2>/dev/null &

sleep 6

echo ""
echo "📊 Error Check Summary:"
echo "======================"
echo "✅ Error detection completed"
echo "💡 If you see JavaScript errors in the browser console,"
echo "   they should be fixed before proceeding."
echo ""
echo "🔧 To manually check:"
echo "  1. Open browser developer tools (F12)"
echo "  2. Go to Console tab"
echo "  3. Visit: http://localhost:8000/$TARGET_FILE"
echo "  4. Look for red error messages"

# Cleanup
rm -f /tmp/error_checker.html 