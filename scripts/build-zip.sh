#!/usr/bin/env bash
# Builds dist/yeah-i-built-that.zip for uploading to Claude desktop/web chat.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/yeah-i-built-that.zip
(cd skills && zip -rq ../dist/yeah-i-built-that.zip yeah-i-built-that -x '*.DS_Store')
echo "Built dist/yeah-i-built-that.zip"
