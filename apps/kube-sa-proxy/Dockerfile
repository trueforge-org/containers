# Stage 1 - Build the Go application
FROM golang:1.25.1-alpine@sha256:b6ed3fd0452c0e9bcdef5597f29cc1418f61672e9d3a2f55bf02e7222c014abd AS builder

USER root

# Install necessary build dependencies
RUN apk --no-cache add --update gcc musl-dev

# Copy go mod and sum files
COPY . /

# Create the necessary directories
RUN mkdir -p /build /output

# Set the working directory
WORKDIR /build

# Download dependencies
RUN go mod download

# Build the Go application
RUN go build -ldflags "-w -s" -o /output/my-proxy-service .

# Stage 2 - Create the final image
FROM ghcr.io/trueforge-org/alpine:3.22.1 AS runner

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /output/my-proxy-service .

# Set environment variables
ENV PORT=3000

# Expose the port
EXPOSE $PORT

# Set the default command to run the binary
CMD ["./my-proxy-service"]
