#!/bin/bash

# Build script for LLM Council
# This script builds the frontend and prepares the application for deployment

set -e

echo "Building LLM Council..."
echo ""

# Build frontend
echo "Building frontend..."
cd frontend
npm install
npm run build
cd ..

echo ""
echo "✓ Frontend built successfully!"
echo "✓ Build output: frontend/dist"
echo ""
echo "To run the production server:"
echo "  uv run python -m backend.main"
echo ""

