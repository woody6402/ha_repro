# OCR Server – Home Assistant Add-on

An OCR server packaged as a Home Assistant Add-on for image recognition (meters, displays, PV, etc.).  
The server exposes an HTTP API, processes images (OCR / TFLite), and can optionally publish results via MQTT.

This repository contains **the Home Assistant Add-on only**, not the core OCR logic itself.  
The OCR logic lives in a separate repository and is included here as a Git submodule.

---

## ✨ Features

- HTTP API (Flask)
- OCR using:
  - Tesseract
  - TFLite (no full TensorFlow dependency)
- Configurable via:
  - **Add-on Options (UI)** for MQTT
  - **YAML file** for OCR layouts & models
- Optimized for HAOS (small image size, no TensorFlow)
- `amd64` architecture supported

---

## 📦 Installation (Home Assistant)

1. **Add the Add-on Repository**

   Home Assistant → Settings → Add-ons → Add-on Store  
   → ⋮ → Repositories  
   → Add repository URL:

   https://github.com/woody6402/ha_repro

2. **Install the OCR Server Add-on**
3. **Configure the Add-on Options**
4. **Start the Add-on**

---

## ⚙️ Configuration

### Add-on Options (UI)

These values are configured via the Add-on UI and will automatically override the MQTT settings
in the server configuration file.

| Option | Description |
|------|-------------|
| config_path | Path to the OCR server configuration file |
| mqtt_host | MQTT broker host |
| mqtt_port | MQTT broker port |
| mqtt_username | MQTT username |
| mqtt_password | MQTT password |
| mqtt_topic_base | Base MQTT topic |

Default value for config_path:

/config/ocr_server/config.yaml

---

## OCR Server Configuration File

The OCR logic is configured via a YAML file on the Home Assistant system:

/config/ocr_server/config.yaml

This file typically contains:

- MQTT structure
- OCR models
- Image regions (rects)
- Regex matching rules
- Transformations

---

## Repository Structure

ha_repro/
├── repository.yaml
└── ocr_server/
    ├── config.yaml        (Add-on manifest)
    ├── Dockerfile
    ├── start.sh
    └── src/
        └── ocr-server/    (OCR logic, submodule)

---

## Configuration Flow

1. Home Assistant writes Add-on options to:
   /data/options.json

2. start.sh:
   - reads options.json
   - loads /config/ocr_server/config.yaml
   - overrides only the mqtt block
   - writes final config to /app/config/config.yaml

3. The OCR server starts with the final configuration.

---

## Debugging

Add-on logs may show the parsed options on startup.

HTTP API test:

curl http://<HA-IP>:5000/

---

## Local Development

docker build -t ocr-addon-test ./ocr_server
docker run --rm -p 5000:5000 -v ./local_config:/config:ro ocr-addon-test

---

## Development Status

- Public repository
- main branch: stable
- dev branch: development / testing
- Versions with -dev suffix are not intended for production use

---

## License

See the respective repositories for license details.

---

## Contributing

Issues and pull requests are welcome.
Changes to OCR logic must be made in the submodule repository.
