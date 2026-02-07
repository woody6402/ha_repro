FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# System dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      tesseract-ocr \
      libglib2.0-0 \
      libsm6 \
      libxext6 \
      libxrender1 \
      libgl1 \
      libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Workdir
WORKDIR /app

# Bring in the OCR server code (submodule)
COPY src/ocr-server/ /app/

# Python deps
RUN pip install --no-cache-dir tflite-runtime && \
    pip install --no-cache-dir -r /app/requirements.txt

# Start wrapper: write HA options server_config into /app/config.yaml if present, then run app
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

EXPOSE 5000
CMD ["/start.sh"]
