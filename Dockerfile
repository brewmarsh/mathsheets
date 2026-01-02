# 1. Base Image
FROM node:18-alpine AS base

# 2. Dependencies
FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# 3. Builder
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Generates the Prisma/Postgres client (if you use an ORM) or just builds the app
RUN npm run build

# 4. Production Runner
FROM base AS runner
WORKDIR /app
ENV NODE_ENV production

# Create a non-root user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy necessary files
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/package.json ./package.json

# Switch to non-root user
USER nextjs

# Default command (can be overridden in docker-compose)
CMD ["node", "server.js"]