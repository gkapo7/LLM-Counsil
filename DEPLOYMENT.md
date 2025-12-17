# Deployment Guide

This guide covers deploying the LLM Council application to production.

## Prerequisites

- An OpenRouter API key from [openrouter.ai](https://openrouter.ai/)
- A deployment platform account (Railway, Render, Fly.io, etc.)

## Environment Variables

Set the following environment variables in your deployment platform:

- `OPENROUTER_API_KEY`: Your OpenRouter API key (required)
- `PORT`: Port number (defaults to 8001, usually auto-set by platform)
- `CORS_ORIGINS`: Comma-separated list of allowed origins (optional, defaults to localhost)

## Deployment Options

### Option 1: Railway (Recommended)

Railway is the easiest platform for deploying this application.

1. **Install Railway CLI** (optional):
   ```bash
   npm i -g @railway/cli
   ```

2. **Deploy via Railway Dashboard**:
   - Go to [railway.app](https://railway.app)
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your repository
   - Railway will automatically detect the configuration

3. **Set Environment Variables**:
   - In Railway dashboard, go to your service → Variables
   - Add `OPENROUTER_API_KEY` with your API key

4. **Deploy**:
   - Railway will automatically build and deploy
   - The build process will:
     - Install Node.js dependencies
     - Build the frontend
     - Install Python dependencies
     - Start the FastAPI server

### Option 2: Render

1. **Create a new Web Service**:
   - Go to [render.com](https://render.com)
   - Click "New" → "Web Service"
   - Connect your GitHub repository

2. **Configure Build Settings**:
   - **Build Command**: `cd frontend && npm install && npm run build && cd .. && uv sync`
   - **Start Command**: `uv run python -m backend.main`
   - **Environment**: Python 3

3. **Set Environment Variables**:
   - Add `OPENROUTER_API_KEY` in the Environment section

4. **Deploy**:
   - Render will build and deploy automatically

### Option 3: Fly.io

1. **Install Fly CLI**:
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Create fly.toml** (already included):
   ```bash
   fly launch
   ```

3. **Set Secrets**:
   ```bash
   fly secrets set OPENROUTER_API_KEY=your-key-here
   ```

4. **Deploy**:
   ```bash
   fly deploy
   ```

### Option 4: Manual Deployment (VPS)

1. **Build the frontend**:
   ```bash
   cd frontend
   npm install
   npm run build
   cd ..
   ```

2. **Install Python dependencies**:
   ```bash
   uv sync
   ```

3. **Set environment variables**:
   ```bash
   export OPENROUTER_API_KEY=your-key-here
   export PORT=8001
   ```

4. **Run the application**:
   ```bash
   uv run python -m backend.main
   ```

5. **Use a process manager** (recommended):
   - Use `systemd`, `supervisor`, or `pm2` to keep the app running
   - Set up a reverse proxy (nginx) to handle SSL and routing

## Post-Deployment

1. **Verify the deployment**:
   - Visit your deployment URL
   - Check that the frontend loads correctly
   - Test creating a conversation and sending a message

2. **Monitor logs**:
   - Check your platform's logs for any errors
   - Verify API calls are working

3. **Data persistence**:
   - Conversations are stored in `data/conversations/` directory
   - On most platforms, this is ephemeral storage
   - For production, consider using a database or persistent volume

## Troubleshooting

### Frontend not loading
- Ensure the frontend build completed successfully
- Check that `frontend/dist` directory exists
- Verify static file serving is configured correctly

### CORS errors
- Set `CORS_ORIGINS` environment variable with your frontend URL
- Ensure the backend allows your frontend origin

### API key errors
- Verify `OPENROUTER_API_KEY` is set correctly
- Check that your OpenRouter account has credits

### Port issues
- Most platforms set `PORT` automatically
- If using a custom port, ensure it matches your platform's configuration

## Custom Domain

To use a custom domain:

1. **Add domain in your platform**:
   - Railway: Settings → Domains
   - Render: Settings → Custom Domains
   - Fly.io: `fly domains add yourdomain.com`

2. **Update CORS_ORIGINS**:
   - Add your custom domain to the `CORS_ORIGINS` environment variable

3. **SSL/HTTPS**:
   - Most platforms provide automatic SSL certificates
   - Ensure HTTPS is enabled

## Scaling

For production use:

- Consider using a database (PostgreSQL, MongoDB) instead of JSON files
- Set up proper logging and monitoring
- Configure rate limiting
- Use a CDN for static assets
- Set up health checks and auto-restart policies

