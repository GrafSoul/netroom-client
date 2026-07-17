# syntax=docker/dockerfile:1

# ---- base: shared by all stages ----
FROM node:24-alpine AS base
WORKDIR /app
COPY package*.json ./

# ---- deps: install dependencies (cacheable layer) ----
FROM base AS deps
RUN npm ci

# ---- dev: Vite dev server with hot-reload ----
FROM deps AS dev
COPY . .
EXPOSE 3000
# --host — reachable from outside the container; --port 3000 — front on 3000 (back on 3030)
CMD ["npm", "run", "dev", "--", "--host", "--port", "3000"]

# ---- build: compile static assets into dist/ ----
# VITE_API_URL is baked into the bundle at build time, so it must be passed
# per environment via --build-arg (dev: localhost, prod: https://api.YOUR_DOMAIN).
FROM deps AS build
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
COPY . .
RUN npm run build

# ---- prod: serve static files via Nginx, no Node ----
FROM nginx:alpine AS prod
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
