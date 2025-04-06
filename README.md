# Igra Orchestra Setup Guide

## Overview

Igra Orchestra is a system that orchestrates the following services:
- **block-builder**: A custom block builder service ([GitHub](https://github.com/IgraLabs/block-builder))
- **execution-layer**: A reth-based execution layer ([GitHub](https://github.com/IgraLabs/execution-layer))
- **kaswallet**: An internal wallet service for Igra L1 ([GitHub](https://github.com/IgraLabs/kaswallet))
- **rpc-provider**: RPC provider for client interactions ([GitHub](https://github.com/IgraLabs/igra-rpc-provider))
- **viaduct**: A service that monitors Kaspa L1, extracts L2-relevant data, and ensures reliable transmission to the L2 network ([GitHub](https://github.com/IgraLabs/rusty-kaspa-private))

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

# Run with default branches
./setup-repos.sh

# Or specify custom branches (in order: block-builder, execution-layer, kaswallet, igra-rpc-provider, rusty-kaspa)
./setup-repos.sh main main main branch_name another_branch
```

### 4. Setup Wallet Keys

The system uses a keys.json file for the kaswallet service. A default one is provided, but you can create your own if needed.

### 5. Build and Run Services

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
- Exposes port 9001 for metrics

### RPC Provider

- Provides RPC endpoints for client interaction
- Listens on port 8535
- Depends on kaswallet service

### Kaswallet

- Handles key management
- Uses a keys.json file for storing keys
- Listens on port 8082 (temporary until we fix access to the kaswallet service inside the docker network)

### Viaduct

- Built from rusty-kaspa
- Provides connectivity to the Kaspa network
- Uses persistent storage for blockchain data

## Maintenance

### Updating Repositories

To update repositories to the latest code:

```bash
# Pull latest changes for all components (using their default branches)
./setup-repos.sh
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
docker rm -f block-builder execution-layer rpc-provider kaswallet viaduct

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
