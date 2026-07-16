# syntax=docker/dockerfile:1

# ---- база: общая для всех стадий ----
FROM node:24-alpine AS base
WORKDIR /app
COPY package*.json ./

# ---- deps: установка зависимостей (кэшируемый слой) ----
FROM base AS deps
RUN npm ci

# ---- dev: Vite dev-сервер с hot-reload ----
FROM deps AS dev
COPY . .
EXPOSE 3000
# --host — виден снаружи контейнера; --port 3000 — фронт на 3000 (бэк на 3030)
CMD ["npm", "run", "dev", "--", "--host", "--port", "3000"]

# ---- build: собираем статику в dist/ ----
FROM deps AS build
COPY . .
RUN npm run build

# ---- prod: раздаём статику через Nginx, без Node ----
FROM nginx:alpine AS prod
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
