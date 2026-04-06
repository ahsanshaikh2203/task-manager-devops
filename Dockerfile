# Use Node.js official image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json
COPY backend/package.json ./

# Install dependencies
RUN npm install --production

# Copy backend and frontend files
COPY backend/ ./backend/
COPY frontend/ ./frontend/

# Expose port
EXPOSE 3000

# Set working directory to backend
WORKDIR /app/backend

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["node", "server.js"]
