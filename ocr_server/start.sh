#!/usr/bin/env bash
set -e

OPTS="/data/options.json"

# Default, falls options.json fehlt:
CONFIG_PATH="/config/ocr_server/config.yaml"

# Falls HA options gesetzt sind, überschreiben:
if [ -f "$OPTS" ]; then
  CONFIG_PATH=$(python3 - << "PY"
import json
from pathlib import Path
opts = json.loads(Path("/data/options.json").read_text())
print(opts.get("config_path", "/config/ocr_server/config.yaml"))
PY
)
fi

# Zielpfad (wie dein OCR-Server ihn erwartet)
TARGET="/app/config/config.yaml"
mkdir -p "$(dirname "$TARGET")"

# Config rüberkopieren (fail fast, wenn sie fehlt)
if [ ! -f "$CONFIG_PATH" ]; then
  echo "ERROR: Config file not found: $CONFIG_PATH"
  echo "Create it in Home Assistant under /config/ocr_server/config.yaml (or adjust config_path option)."
  exit 1
fi

cp -f "$CONFIG_PATH" "$TARGET"

exec python3 /app/app.py

