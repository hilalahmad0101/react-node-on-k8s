# Use Node slim base image for smaller size
FROM node:18-slim as builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Create production image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built application from builder
COPY --from=builder /app ./

# Add non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

USER appuser

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]
