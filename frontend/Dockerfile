# FROM node:20-alpine AS base
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci

# FROM node:alpine
# WORKDIR /app
# COPY --from=base /app/node_modules ./node_modules
# COPY . .
# EXPOSE 3000
# CMD [ "npm", "start" ]

# FROM node:20-alpine as build
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# RUN npm run build

# # Production stage
# FROM nginx:alpine
# WORKDIR /usr/share/nginx/html
# RUN rm -rf ./*
# COPY --from=build /app/build ./
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# # #


# STAGE 1: Build & Dependencies
FROM node:20-alpine AS builder

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec9ee063c5a3153e2#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy lockfiles first to leverage Docker cache
COPY package*.json ./

# Install ALL dependencies (including devDependencies for build steps)
RUN npm ci

# Copy source code and build (e.g., for TypeScript or bundling)
COPY . .
RUN npm run build

# Clean up devDependencies to keep the final image lean
RUN npm prune --production



# STAGE 2: Runtime
FROM node:20-alpine AS runner

WORKDIR /app

# Set production environment
ENV NODE_ENV=production
ENV PORT=3000

# 1. Security: Create a dedicated non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodeapp

# 2. Security: Copy only necessary artifacts from builder
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder --chown=nodeapp:nodejs /app/dist ./dist

# Set proper ownership
RUN chown -R nodeapp:nodejs /app

# Switch to the non-root user
USER nodeapp

EXPOSE 3000

# 3. Security: Use 'node' directly to handle signals correctly
CMD ["node", "dist/index.js"]