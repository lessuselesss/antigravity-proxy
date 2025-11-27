#!/usr/bin/env bash

# Launch Antigravity with proxy settings

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Launching Antigravity with Proxy${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Load configuration from .env
if [ -f .env ]; then
    source .env
else
    echo -e "${RED}❌ .env file not found!${NC}"
    echo -e "${YELLOW}💡 Copy .env.example to .env and configure your API key:${NC}"
    echo -e "   cp .env.example .env"
    exit 1
fi

# Check if ANTIGRAVITY_PATH is set
if [ -z "$ANTIGRAVITY_PATH" ]; then
    echo -e "${RED}❌ ANTIGRAVITY_PATH is not set!${NC}"
    echo -e "${YELLOW}💡 Please set ANTIGRAVITY_PATH in your .env file to the location of the Antigravity application.${NC}"
    exit 1
fi

# Check if Antigravity exists at the specified path
if [ ! -f "$ANTIGRAVITY_PATH" ]; then
    echo -e "${RED}❌ Antigravity not found at: ${ANTIGRAVITY_PATH}${NC}"
    echo -e "${YELLOW}💡 Make sure the path in your .env file is correct.${NC}"
    exit 1
fi

# Proxy configuration
PROXY_PORT=${PROXY_PORT:-8080}
PROXY_URL="http://localhost:${PROXY_PORT}"

echo -e "${GREEN}✓ Found Antigravity at: ${ANTIGRAVITY_PATH}${NC}"
echo -e "${GREEN}✓ Using proxy: ${PROXY_URL}${NC}"
echo -e "${BLUE}Starting Antigravity...${NC}"
echo ""

# Launch Antigravity with proxy environment variables
HTTP_PROXY="$PROXY_URL" \
HTTPS_PROXY="$PROXY_URL" \
SSL_CERT_FILE="$(pwd)/certs/mitmproxy-ca-cert.pem" \
"$ANTIGRAVITY_PATH" "$@"
