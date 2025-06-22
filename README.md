# Visualization Testing Scripts

This folder contains WebGL visualizations and testing utilities.

## Scripts

### `./start-server.sh [port]`
Starts HTTP server in the background without opening browser.
- Default port: 8000
- Creates `.server.pid` file to track server process
- Logs to `server.log`

### `./test-pages.sh [port]`
Tests visualization pages **without opening browser**.
- Uses curl to check if pages are accessible
- Validates HTML structure
- Shows status without visual interference

### `./open-browser.sh [page] [port]`
**Only use when you want to actually open the browser.**
- `./open-browser.sh` - Opens main visualization
- `./open-browser.sh debug` - Opens debug version
- `./open-browser.sh both` - Opens both pages

### `./stop-server.sh`
Cleanly stops the server and cleans up files.

## Typical Workflow

```bash
# Start server (no browser opens)
./start-server.sh

# Test if everything works (no browser opens)
./test-pages.sh

# When you're ready to see it, open browser manually
./open-browser.sh

# Stop server when done
./stop-server.sh
```

## Files

- `index.html` - Main geometric visualization
- `debug.html` - Simple test version
- `backups/` - Saved versions of visualizations

## Server Management

- **PID tracking**: Server process ID stored in `.server.pid`
- **Logging**: Server output goes to `server.log`
- **Auto-cleanup**: Stop script removes temporary files
- **Port detection**: Scripts check if server is already running

## Customization

All scripts accept port numbers as arguments:
```bash
./start-server.sh 3000
./test-pages.sh 3000
./open-browser.sh index 3000
```
