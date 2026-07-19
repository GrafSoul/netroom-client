# netroom-client

Client single-page app for **netroom** — React + TypeScript, built with Vite.
Talks to the `netroom-server` API.

## The netroom project

**netroom** is split into four repositories, developed and deployed independently:

| Repository                                                       | Role                                       | Local dev               |
| ---------------------------------------------------------------- | ------------------------------------------ | ----------------------- |
| [netroom-server](https://github.com/GrafSoul/netroom-server) | Backend API (NestJS)                       | `http://localhost:3030` |
| [netroom-client](https://github.com/GrafSoul/netroom-client) | Client SPA (React + Vite)                  | `http://localhost:3000` |
| [netroom-admin](https://github.com/GrafSoul/netroom-admin)   | Admin SPA (React + Vite)                   | `http://localhost:3001` |
| [netroom-infra](https://github.com/GrafSoul/netroom-infra)   | Production orchestration (Compose + Caddy) | —                       |

In production each app is served on its own subdomain (`api.` / `app.` / `admin.`)
behind a single Caddy reverse proxy. See
[netroom-infra](https://github.com/GrafSoul/netroom-infra) for deployment.

## Tech stack

- **React 19** + **TypeScript**
- **Vite 8** — dev server with HMR and production build
- **ESLint** — flat config with React Hooks / React Refresh rules
- **Docker** — multi-stage build (Vite dev server / Nginx-served static in prod)

## Prerequisites

- Node.js 24+ and npm, and/or
- [Docker](https://docs.docker.com/get-docker/) + Docker Compose

## Getting started (local development)

```bash
npm install
cp .env.example .env
npm run dev              # http://localhost:3000
```

## Environment variables

Only variables prefixed with `VITE_` are exposed to the client bundle — never put
secrets there, they ship to the browser. In production `VITE_API_URL` is injected
at **image build time** via a build-arg (see
[netroom-infra](https://github.com/GrafSoul/netroom-infra)), not read from a file.

| Variable       | Description                   | Default                 |
| -------------- | ----------------------------- | ----------------------- |
| `VITE_API_URL` | Base URL of the netroom API | `http://localhost:3030` |

## Scripts

| Command           | What it does                                      |
| ----------------- | ------------------------------------------------- |
| `npm run dev`     | Start the Vite dev server with hot-reload         |
| `npm run build`   | Type-check (`tsc -b`) and build production bundle |
| `npm run preview` | Preview the production build locally              |
| `npm run lint`    | Run ESLint over the project                       |

## Docker

The `Dockerfile` is multi-stage:

- **dev** — runs the Vite dev server with hot-reload
- **prod** — serves the built static files through Nginx (SPA fallback to `index.html`)

```bash
# Development with Compose — code mounted for hot-reload, on http://localhost:3000
docker compose up

# Production image — API URL is baked in at build time
docker build --target prod --build-arg VITE_API_URL=https://api.YOUR_DOMAIN -t netroom-client .
docker run -p 8080:80 netroom-client        # http://localhost:8080
```

## Project structure

```text
src/
├── assets/        # static assets imported by components
├── App.tsx        # root component
├── main.tsx       # app entry point
├── App.css        # component styles
└── index.css      # global styles
```

## Deployment

Production is orchestrated from
[netroom-infra](https://github.com/GrafSoul/netroom-infra): the `prod` image is
served by Caddy at `https://app.YOUR_DOMAIN`.

## License

Private project — not for distribution.
