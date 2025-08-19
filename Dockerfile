FROM docker.io/library/golang:1.23 AS builder

# Install gcp-nuke
RUN go install github.com/ekristen/gcp-nuke@latest

FROM docker.io/library/debian:bookworm-slim

# Install ca-certificates for HTTPS requests
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/gcp-nuke /usr/local/bin/gcp-nuke

WORKDIR /app
COPY config.yml .

CMD ["gcp-nuke", "run", "--config", "config.yml", "--no-prompt", "--no-dry-run", "--project-id", "${PROJECT_ID}"]
