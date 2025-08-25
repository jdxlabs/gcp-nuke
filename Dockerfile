FROM docker.io/library/golang:1.23 AS builder

# Install gcp-nuke
RUN go install github.com/ekristen/gcp-nuke@latest

FROM docker.io/library/debian:bookworm-slim

# Install ca-certificates for HTTPS requests and gcloud CLI
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/gcp-nuke /usr/local/bin/gcp-nuke

WORKDIR /app
COPY config.yml .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]
