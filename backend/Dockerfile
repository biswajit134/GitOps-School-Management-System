# FROM node:20-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# EXPOSE 5000
# CMD ["npm", "start"]


# --- Stage 1: Build & Dependencies ---
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency manifests first to leverage Docker layer caching
COPY package*.json ./

# Install ONLY production dependencies and omit devDependencies
# 'npm ci' is preferred in CI/CD as it's faster and strictly matches package-lock.json
RUN npm ci --only=production

# Copy the rest of the application source code
COPY . .

# Optional: If you use TypeScript or a bundler, run your build command here
# RUN npm run build


# --- Stage 2: Lean Runtime ---
FROM node:20-alpine AS runner

# Set production environment variables
ENV NODE_ENV=production
ENV PORT=5000

WORKDIR /app

# 1. Security: Create and use a non-root user. 
# Node alpine images come with a 'node' user; we just need to set permissions.
RUN chown -R node:node /app

# 2. Copy only the necessary artifacts from the builder stage
# This keeps the final image tiny by excluding the npm cache and source-code-only files
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package*.json ./
COPY --from=builder --chown=node:node /app/ .

# 3. Switch to the non-root user
USER node

# 4. Documentation
EXPOSE 5000

# 5. Healthcheck: Critical for Orchestrators (K8s/ECS) to know the app is actually alive
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5000/health || exit 1

# 6. Use 'node' directly rather than 'npm start'
# This allows Node to receive OS signals (SIGTERM) for graceful shutdowns.
CMD ["node", "index.js"]