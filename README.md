# Igra Orchestra Setup Guide

## Overview

Igra Orchestra is a system that orchestrates two main services:
- **block-builder**: A custom block builder service ([GitHub](https://github.com/IgraLabs/block-builder))
- **execution-layer**: A reth-based execution layer ([GitHub](https://github.com/IgraLabs/execution-layer))

This guide explains how to set up and run the system locally for development.

## Prerequisites

- Git
- Docker & Docker Compose
- SSH access to GitHub repositories

## Setup Process

### 1. Clone This Repository

```bash
git clone git@github.com:IgraLabs/igra-orchestra.git
cd igra-orchestra
```

### 2. Create JWT Secret

The JWT secret is used for secure communication between services:

```bash
# Generate JWT secret
openssl rand -hex 32 > jwt.hex

# Set proper permissions
chmod 600 jwt.hex
```

### 3. Run Setup Script

This script clones the service repositories and checks out specified branches:

```bash
# Make script executable
chmod +x setup-repos.sh

# Run with default branches (main)
./setup-repos.sh

# Or specify custom branches
./setup-repos.sh develop feature-branch
```

### 4. Build and Run Services

```bash
# Start the services
docker compose up

# Or run in detached mode
docker compose up -d

# To rebuild containers
docker compose up --build
```

## Component Details

### JWT Authentication

JWT is used for secure authentication between the block-builder and execution-layer. The same JWT secret must be mounted to both services.

- In block-builder: `/app/jwt.hex`
- In execution-layer: `/root/reth/jwt.hex`

### Block Builder

- Built from source in the block-builder repository
- Connects to the execution layer using the JWT for secure communication
- Listens on port 8561

### Execution Layer

- Uses the ghcr.io/paradigmxyz/reth image
- Runs with a custom genesis configuration
- Uses a startup script from the repository
- Exposes multiple ports:
  - 9001: Metrics

## Maintenance

### Updating Repositories

To update repositories to the latest code:

```bash
# Pull latest changes for specific branches
./setup-repos.sh main main
```

### Cleaning Up

```bash
# Stop and remove containers
docker compose down

# Remove volumes as well
docker compose down -v
```

## Troubleshooting

### Container Name Conflicts

If you encounter container name conflicts:

```bash
# Remove existing containers
docker rm -f block-builder execution-layer

# Then try again
docker compose up
```

### Volume Mount Issues

If you have problems with volume mounts:

1. Ensure files exist and have proper permissions
2. For jwt.hex, ensure it has mode 600
3. Check that paths in docker-compose.yml match your directory structure


## License

[TODO]
