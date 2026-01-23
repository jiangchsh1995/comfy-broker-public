FROM python:3.12-alpine

RUN apk add --no-cache bash curl ca-certificates s6-overlay \
 && update-ca-certificates

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# cloudflared
RUN mkdir -p /etc/cloudflared \
 && curl -fsSL -o /usr/local/bin/cloudflared \
    https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
 && chmod +x /usr/local/bin/cloudflared

COPY app.so /app/
COPY main.py /app/main.py
COPY rootfs/ /

ENV S6_KEEP_ENV=1
ENV DATA_DIR=/data
ENV PORT=8080

EXPOSE 8080
ENTRYPOINT ["/init"]
