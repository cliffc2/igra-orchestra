#!/bin/bash
# setup-repos.sh - Clone and setup repositories for Igra Orchestra

# Function for timestamped log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting repository setup"

# Default branches
BLOCK_BUILDER_BRANCH=${1:-main}
EXECUTION_LAYER_BRANCH=${2:-main}

log "Using branches:"
log "  - block-builder: $BLOCK_BUILDER_BRANCH"
log "  - execution-layer: $EXECUTION_LAYER_BRANCH"

# Create repos directory
log "Creating repos directory if it doesn't exist..."
if [ ! -d "repos" ]; then
    mkdir -p repos
    log "Created directory: repos"
else
    log "Directory repos already exists"
fi

# Setup block-builder repository
log "Setting up block-builder repository"
if [ ! -d "repos/block-builder" ]; then
    log "Cloning block-builder repository..."
    git clone git@github.com:IgraLabs/block-builder.git repos/block-builder
    if [ $? -eq 0 ]; then
        log "Successfully cloned block-builder repository"
    else
        log "ERROR: Failed to clone block-builder repository"
        exit 1
    fi
else
    log "block-builder repository already exists, skipping clone"
fi

# Setup execution-layer repository
log "Setting up execution-layer repository"
if [ ! -d "repos/execution-layer" ]; then
    log "Cloning execution-layer repository..."
    git clone git@github.com:IgraLabs/execution-layer.git repos/execution-layer
    if [ $? -eq 0 ]; then
        log "Successfully cloned execution-layer repository"
    else
        log "ERROR: Failed to clone execution-layer repository"
        exit 1
    fi
else
    log "execution-layer repository already exists, skipping clone"
fi

# Configure block-builder repository
log "Configuring block-builder repository"
cd repos/block-builder
log "Current directory: $(pwd)"
log "Fetching latest changes..."
git fetch
if [ $? -ne 0 ]; then
    log "ERROR: Failed to fetch changes for block-builder"
    exit 1
fi

log "Checking out branch: $BLOCK_BUILDER_BRANCH"
git checkout $BLOCK_BUILDER_BRANCH
if [ $? -ne 0 ]; then
    log "ERROR: Failed to checkout branch $BLOCK_BUILDER_BRANCH for block-builder"
    exit 1
fi

log "Pulling latest changes..."
git pull
if [ $? -ne 0 ]; then
    log "ERROR: Failed to pull latest changes for block-builder"
    exit 1
fi

log "Current branch info for block-builder:"
git branch -v

# Configure execution-layer repository
log "Configuring execution-layer repository"
cd ../execution-layer
log "Current directory: $(pwd)"
log "Fetching latest changes..."
git fetch
if [ $? -ne 0 ]; then
    log "ERROR: Failed to fetch changes for execution-layer"
    exit 1
fi

log "Checking out branch: $EXECUTION_LAYER_BRANCH"
git checkout $EXECUTION_LAYER_BRANCH
if [ $? -ne 0 ]; then
    log "ERROR: Failed to checkout branch $EXECUTION_LAYER_BRANCH for execution-layer"
    exit 1
fi

log "Pulling latest changes..."
git pull
if [ $? -ne 0 ]; then
    log "ERROR: Failed to pull latest changes for execution-layer"
    exit 1
fi

log "Current branch info for execution-layer:"
git branch -v

# Return to root directory
cd ../../
log "Returned to directory: $(pwd)"

log "==REPOSITORY SETUP COMPLETED SUCCESSFULLY=="
log "Repositories configured successfully:"
log "  - block-builder: $BLOCK_BUILDER_BRANCH"
log "  - execution-layer: $EXECUTION_LAYER_BRANCH"
log ""
log "You can now run docker-compose build && docker-compose up"