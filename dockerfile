
# Stage 1: Builder
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production && mkdir -p node_modules

# Copy source files
COPY server.js ./


# Stage 2: Runner
FROM node:20-alpine

WORKDIR /usr/src/app

# Use non-root user
USER node

# Copy dependencies
COPY --from=builder --chown=node:node /usr/src/app/node_modules ./node_modules

# Copy application source
COPY --from=builder --chown=node:node /usr/src/app/server.js ./server.js

# Expose port
EXPOSE 3000

# Start application
CMD ["node", "server.js"]
