# Tauri + Vue + TypeScript Template

This template provides a starting point for developing desktop applications using [Tauri](https://tauri.app/), [Vue 3](https://vuejs.org/), and [TypeScript](https://www.typescriptlang.org/).

## Features:
- A cleaner project structure with frontend and backend code in peer directories.
- Pre-configured github actions
    - [ci](.github/workflows/ci.yml) for code quality checks
    - [build-check](.github/workflows/build-check.yml) for a basic build verification
    - [release](.github/workflows/release.yml)
- Pre-configured tasks in 'package.json'
- Modern Vue 3 with Composition API and `<script setup>`
- Vite for fast development and optimized builds


## Project Structure

Unlike typical Tauri templates where frontend code is at the root level, this template uses a peer directory structure:

```
template-tauri-vue/
├── src-vue/     # Frontend Vue 3 application
└── src-tauri/   # Rust and Tauri backend code
```

This organization keeps the frontend and backend code cleanly separated while maintaining them at the same level in the project hierarchy.

## Prerequisites

- [Node.js](https://nodejs.org/) (with npm or pnpm)
- [Rust](https://www.rust-lang.org/tools/install)
- [Tauri CLI](https://tauri.app/v1/guides/getting-started/prerequisites)

## Setup Instructions

Before running any Tauri commands, you must install the Node.js dependencies in the frontend directory:

```bash
pnpm run project:init
```

## Development Commands

You can use either cargo or pnpm to run Tauri commands:

### Using cargo

```bash
# Run the app in development mode
cargo tauri dev

# Build the app for production
cargo tauri build
```

### Using pnpm

```bash
# Run the app in development mode
pnpm tauri dev

# Build the app for production
pnpm tauri build
```

## Additional Resources

- [Tauri Documentation](https://tauri.app/v1/guides/)
- [Vue 3 Documentation](https://vuejs.org/)
- [Vite Documentation](https://vite.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
