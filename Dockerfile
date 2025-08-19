FROM docker.io/library/golang:1.23 AS builder

# Install gcp-nuke
RUN go install github.com/ekristen/gcp-nuke@latest

FROM docker.io/library/debian:bookworm-slim
COPY --from=builder /go/bin/gcp-nuke /usr/local/bin/gcp-nuke

WORKDIR /app
COPY config.yml .

ENV PROJECT_ID="changeme"

CMD ["sh", "-c", "gcp-nuke run --config config.yml --no-prompt --no-dry-run --project-id ${PROJECT_ID}"]
