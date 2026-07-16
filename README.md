# dev-vault-client

Frontend for **dev-vault** — a React + TypeScript single-page app built with Vite.
Talks to the `dev-vault-server` API (default `http://localhost:3030`).

## Tech stack

- **React 19** + **TypeScript**
- **Vite 8** — dev server with HMR and production build
- **ESLint** — flat config with React Hooks / React Refresh rules
- **Docker** — multi-stage build (Vite dev server / Nginx-served static in prod)

## Requirements

- Node.js 24+ and npm (for local development)
- Docker + Docker Compose (optional, for containerized runs)

## Getting started

```bash
# 1. Install dependencies
npm install

# 2. Create your local env file from the template
cp .env.example .env

# 3. Start the dev server (http://localhost:5173)
npm run dev
```

## Environment variables

Copy `.env.example` to `.env` and adjust values. Only variables prefixed with
`VITE_` are exposed to the client bundle — never put secrets there, they ship to
the browser.

| Variable       | Description                   | Default                 |
| -------------- | ----------------------------- | ----------------------- |
| `VITE_API_URL` | Base URL of the dev-vault API | `http://localhost:3030` |

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

### Development with Compose

```bash
# Starts the dev stage, code mounted for hot-reload, on http://localhost:3000
docker compose up
```

### Production image

```bash
# Build the Nginx-served static image
docker build --target prod -t dev-vault-client .

# Run it on http://localhost:8080
docker run -p 8080:80 dev-vault-client
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

## License

Private — not for distribution.
