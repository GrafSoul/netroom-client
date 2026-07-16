/// <reference types="vite/client" />

interface ImportMetaEnv {
  /** Backend API base URL (see .env). */
  readonly VITE_API_URL: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
