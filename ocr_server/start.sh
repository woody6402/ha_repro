#!/usr/bin/env bash
set -e

OPTS="/data/options.json"

if [ -f "$OPTS" ]; then
  python3 - << "PY"
import json
from pathlib import Path

opts = json.loads(Path("/data/options.json").read_text())
raw = opts.get("server_config")
if raw and isinstance(raw, str):
    Path("/app/config.yaml").write_text(raw, encoding="utf-8")
PY
fi

exec python3 /app/app.py

