import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

const host = 'localhost'
const port = parseInt(process.env.TAURI_DEV_PORT || '1420')

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue(), tailwindcss()],

  // Vite options tailored for Tauri development
  clearScreen: false,

  server: {
    port,
    strictPort: true,
    host: host || false,
    hmr: host
      ? {
          protocol: "ws",
          host,
          port: port + 1,
        }
      : undefined,
  },
})
