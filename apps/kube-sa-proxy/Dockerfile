# Stage 1 - Build the Go application
FROM ghcr.io/trueforge-org/go-alpine:1.25.1 AS builder

USER root

# Install necessary build dependencies
RUN apk --no-cache add --update gcc musl-dev

# Copy go mod and sum files
COPY . /

# Create the necessary directories
RUN mkdir -p /build /output && cd /build && ls /build

# Set the working directory
WORKDIR /build

# Download dependencies
RUN cd /build && go mod download

# Build the Go application
RUN cd /build && go build -ldflags "-w -s" -o /output/my-proxy-service .

# Stage 2 - Create the final image
FROM ubuntu:24.04 AS runner

# Install runtime dependencies if needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /output/my-proxy-service .

# Set environment variables
ENV PORT=3000

# Expose the port
EXPOSE $PORT

# Set default command to run the binary
CMD ["./my-proxy-service"]
