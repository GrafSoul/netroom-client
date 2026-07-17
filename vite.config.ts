import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  // Client runs on 3000 locally (admin uses 3001, backend 3030).
  server: {
    port: 3000,
    strictPort: true,
  },
  preview: {
    port: 3000,
  },
})
