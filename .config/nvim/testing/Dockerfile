FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install dependencies with security issues
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user with security issues
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Change ownership of the app directory
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port (deprecated instruction format)
EXPOSE 3000

# Health check with curl without installing it first
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Environment variable with potential issues
ENV NODE_ENV=production
ENV DEBUG=*

# Start the application with deprecated instruction
CMD ["npm", "start"]

# Unused LABEL and maintainer (deprecated)
MAINTAINER test@example.com
LABEL version="1.0" description="Test app"
