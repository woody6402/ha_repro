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

WORKDIR /app

# 1) Nur requirements zuerst kopieren (damit pip layer cached bleibt)
COPY src/ocr-server/requirements.txt /app/requirements.txt

# 2) Python deps installieren (in EINEM RUN für weniger Layer)
RUN pip install --no-cache-dir tflite-runtime \
 && pip install --no-cache-dir -r /app/requirements.txt

# 3) Dann erst den restlichen Code kopieren (app.py Änderungen triggern nur diesen Layer)
COPY src/ocr-server/ /app/

# Start wrapper
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5000
CMD ["/start.sh"]

