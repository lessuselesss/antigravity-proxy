#!/usr/bin/env bash

# Get the directory of the script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Antigravity Proxy and App...${NC}"

# Start mitmdump in the background using nix develop
echo -e "${YELLOW}Starting mitmproxy in the background...${NC}"
nix develop -c bash -c "mitmdump -s ${SCRIPT_DIR}/mitmproxy-addon.py --listen-port 8080" > /tmp/mitmproxy.log 2>&1 &
MITM_PID=$!

# Give the proxy a moment to start
sleep 2

# Check if the proxy started successfully
if ! kill -0 $MITM_PID 2>/dev/null; then
    echo -e "${RED}❌ mitmproxy failed to start. Check /tmp/mitmproxy.log for details.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ mitmproxy started with PID ${MITM_PID}${NC}"

# Set up a trap to kill the proxy when the script exits
trap "echo -e '${YELLOW}Killing mitmproxy (PID: ${MITM_PID})...${NC}'; kill ${MITM_PID} 2>/dev/null" EXIT

# Launch the application
"${SCRIPT_DIR}/scripts/launch-antigravity.sh"

echo -e "${BLUE}Antigravity application is running in the background.${NC}"
echo -e "${YELLOW}Proxy is active. Logs are streaming below.${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop the proxy and exit...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Stream the logs to the console
tail -f -n +1 /tmp/mitmproxy.log
