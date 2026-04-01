# Architecture

This document describes the project structure, technology stack, development workflow, and conventions for the `template-tauri-vue` template.

## Tech Stack

| Layer    | Technology                     | Purpose                          |
| -------- | ------------------------------ | -------------------------------- |
| Desktop  | Tauri 2                        | Native desktop shell + APIs      |
| Frontend | Vue 3 + TypeScript             | UI framework (Composition API)   |
| Build    | Vite 7                         | Dev server + bundler             |
| Styling  | Tailwind CSS 4                 | Utility-first CSS                |
| Backend  | Rust (edition 2021)            | Native capabilities via Tauri    |
| Testing  | Vitest (frontend), Cargo test  | Unit/integration testing         |
| Stories  | Storybook 10                   | Component development/preview    |

## Project Structure

```
template-tauri-vue/
├── src-vue/                 # Vue 3 frontend application
│   ├── src/
│   │   ├── assets/          # Static assets (images, fonts)
│   │   ├── components/      # Vue components
│   │   ├── stories/         # Storybook stories + story components
│   │   ├── App.vue          # Root component
│   │   ├── main.ts          # Application entry point
│   │   ├── style.css        # Global styles (Tailwind imports)
│   │   └── no-bounce.css    # Overscroll prevention
│   ├── public/              # Static files served as-is
│   ├── vite.config.ts       # Vite + Tailwind + Vue plugin config
│   ├── eslint.config.mjs    # ESLint flat config
│   ├── tsconfig.json        # TypeScript project references
│   ├── oxlint.json          # oxlint configuration
│   └── package.json         # Frontend dependencies + scripts
│
├── src-tauri/               # Rust / Tauri backend
│   ├── src/
│   │   ├── main.rs          # Application entry point
│   │   └── lib.rs           # Library entry (Tauri setup)
│   ├── icons/               # App icons (all platforms)
│   ├── Cargo.toml           # Rust dependencies
│   └── tauri.conf.json      # Tauri configuration
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml           # Lint, format, typecheck, test
│   │   ├── build-check.yml  # Full Tauri build verification
│   │   └── release.yml      # Cross-platform release builds
│   └── dependabot.yml       # Automated dependency updates
│
├── .scripts/                # Shell scripts for backend checks
│   ├── backend-lint         # cargo clippy wrapper
│   ├── backend-format-check # cargo fmt --check wrapper
│   └── backend-test         # cargo test wrapper
│
├── scripts/                 # Utility scripts
│   ├── dev-port.sh          # Smart port assignment per worktree
│   └── tauri-wrapper.mjs    # Node wrapper for Tauri CLI
│
├── docs/                    # Documentation
├── Makefile                 # Make targets (see Commands below)
├── justfile                 # Just targets (mirrors Makefile)
├── lefthook.yml             # Git hook configuration
├── commitlint.config.ts     # Conventional commit enforcement
├── mise.toml                # Tool version management
├── .editorconfig            # Editor formatting rules
├── .release-it.json         # Release automation config
├── pnpm-workspace.yaml      # pnpm workspace (includes src-vue)
└── package.json             # Root dependencies + task scripts
```

The frontend and backend live as **peer directories** (`src-vue/` and `src-tauri/`) rather than nesting the frontend at the project root. This keeps concerns cleanly separated.

## Development Workflow

### Prerequisites

- **Node.js** (LTS) and **pnpm** 10.30.3 — managed via [mise](https://mise.jdx.dev/)
- **Rust** 1.93.0 — managed via mise
- System dependencies for Tauri (see [Tauri prerequisites](https://tauri.app/start/prerequisites/))

### Setup

```bash
mise install          # Install tool versions
pnpm run project:init # Install all dependencies
pnpm lefthook install # Set up git hooks
# or simply:
make setup
```

### Running

| Command          | Description                                    |
| ---------------- | ---------------------------------------------- |
| `make dev`       | Start Tauri dev server (Vite + Rust)           |
| `make storybook` | Launch Storybook for component development     |
| `make build`     | Production build                               |
| `make test`      | Run all tests (frontend + Rust)                |
| `make lint`      | Run all linters (ESLint + Clippy)              |
| `make ci`        | Full CI pipeline locally                       |
| `make ports`     | Show auto-assigned port block for this worktree |

All `make` targets have equivalent `just` targets. Run `just --list` or `make help` to see all available commands.

### Port Assignment

Dev server ports are auto-assigned per git worktree via `scripts/dev-port.sh`, avoiding collisions when multiple worktrees run simultaneously. Ports are exposed as environment variables through `mise.toml`:

- `TAURI_DEV_PORT` — Vite dev server (default: 1420)
- `STORYBOOK_PORT` — Storybook dev server
- `MCP_PORT` — MCP service
- `HTTP_PORT` — HTTP service

## Code Quality

### Linting & Formatting

| Tool       | Scope    | Purpose                           |
| ---------- | -------- | --------------------------------- |
| ESLint     | Frontend | Code quality rules (flat config)  |
| oxlint     | Frontend | Fast Rust-based lint pass         |
| Prettier   | Frontend | Code formatting                   |
| Clippy     | Backend  | Rust lints (`-D warnings`)        |
| `cargo fmt`| Backend  | Rust formatting                   |

### Git Hooks (Lefthook)

Pre-commit hooks run **in parallel** for fast feedback:

- `frontend-lint` — ESLint
- `frontend-typecheck` — vue-tsc
- `frontend-test` — Vitest
- `backend-lint` — Clippy
- `backend-format-check` — cargo fmt --check
- `backend-test` — cargo test

Commit messages are validated against [Conventional Commits](https://www.conventionalcommits.org/) via commitlint.

### EditorConfig

The `.editorconfig` enforces consistent formatting across editors:

- 2-space indentation (default)
- 4-space indentation for Rust files
- Tab indentation for Makefiles
- LF line endings, UTF-8, trailing whitespace trimmed

## CI/CD

### CI Pipeline (ci.yml)

Triggers on pushes and PRs to `main`. Two parallel jobs:

**Frontend** (Ubuntu latest):
1. Lint (ESLint)
2. Format check (Prettier)
3. Type check (vue-tsc)
4. Test (Vitest)

**Rust** (Ubuntu 22.04):
1. Format check (`cargo fmt --check`)
2. Clippy lints
3. Tests (`cargo test`)

### Build Check (build-check.yml)

Runs a full `pnpm tauri build --ci` to verify the application compiles and bundles on every push/PR to `main`.

### Release (release.yml)

Triggered by `v*` tags. Builds for all platforms in a matrix:

| Platform        | Target                    |
| --------------- | ------------------------- |
| macOS           | `aarch64-apple-darwin`    |
| macOS           | `x86_64-apple-darwin`     |
| Ubuntu 22.04    | Default                   |
| Windows         | Default                   |

Uses `tauri-apps/tauri-action` to produce platform-specific installers and creates a draft GitHub release.

### Dependabot

Monitors three dependency ecosystems weekly:
- npm (root)
- npm (src-vue)
- Cargo (src-tauri)

## Conventions

### Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add user preferences dialog
fix: resolve window resize flicker on macOS
chore: update Tauri CLI to 2.10.0
```

Enforced by commitlint on every commit via the Lefthook `commit-msg` hook.

### Releases

Managed by [release-it](https://github.com/release-it/release-it):

```bash
pnpm run release
```

This bumps the version in `package.json` and `Cargo.toml`, creates a git tag (`vX.Y.Z`), and commits with `chore: release vX.Y.Z`. The tag push triggers the release CI workflow.

### Frontend

- **Vue 3 Composition API** with `<script setup>` syntax
- **TypeScript** strict mode enabled
- Components in `src-vue/src/components/`
- Stories alongside components in `src-vue/src/stories/`

### Backend

- **Rust edition 2021**
- Tauri command handlers in `src-tauri/src/lib.rs`
- Application bootstrap in `src-tauri/src/main.rs`
