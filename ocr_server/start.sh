#!/usr/bin/env bash
set -e

python3 - << "PY"
import json
from pathlib import Path
import yaml

opts_path = Path("/data/options.json")
opts = json.loads(opts_path.read_text()) if opts_path.exists() else {}

config_path = opts.get("config_path", "/config/ocr_server/config.yaml")
src = Path(config_path)
if not src.exists():
    raise SystemExit(f"ERROR: Config file not found: {src}")

cfg = yaml.safe_load(src.read_text(encoding="utf-8")) or {}
cfg.setdefault("mqtt", {})

# Override mqtt from add-on options
cfg["mqtt"]["host"] = opts.get("mqtt_host", cfg["mqtt"].get("host"))
cfg["mqtt"]["port"] = int(opts.get("mqtt_port", cfg["mqtt"].get("port", 1883)))
cfg["mqtt"]["username"] = opts.get("mqtt_username", cfg["mqtt"].get("username"))
cfg["mqtt"]["password"] = opts.get("mqtt_password", cfg["mqtt"].get("password", ""))
cfg["mqtt"]["topic_base"] = opts.get("mqtt_topic_base", cfg["mqtt"].get("topic_base"))

target = Path("/app/config/config.yaml")
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(
    yaml.safe_dump(cfg, sort_keys=False, allow_unicode=True),
    encoding="utf-8"
)
PY

exec python3 /app/app.py

