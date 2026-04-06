# Default recipe: show help
default:
    @just --list

## Development ---------------------------------------------------------------

# Run tauri dev server (auto-assigned port)
dev:
    pnpm tauri dev

# Build for production
build:
    pnpm tauri build

# Build with debug symbols
build-debug:
    pnpm tauri build --debug

# Launch Storybook dev server (auto-assigned port)
storybook:
    pnpm run storybook

# Show auto-assigned port block for this worktree
ports:
    @scripts/dev-port.sh --all

## Linting & Formatting ------------------------------------------------------

# Run all linters (frontend + Rust)
lint:
    pnpm run frontend:lint
    cd src-tauri && cargo clippy -- -D warnings

# Auto-fix lint issues
lint-fix:
    cd src-vue && pnpm eslint . --fix
    cd src-tauri && cargo clippy --fix --allow-dirty

# Format all code
format:
    pnpm run format

# Check formatting without changes
format-check:
    pnpm run format:check
    cd src-tauri && cargo fmt -- --check

# Run frontend type checking
typecheck:
    pnpm run frontend:typecheck

# Run all code checks (lint + format-check + typecheck)
full-check: lint format-check typecheck
alias fc := full-check

# Auto-fix all formatting (frontend + Rust)
full-write:
    pnpm run format
    cd src-tauri && cargo fmt --all
alias fw := full-write

## Testing -------------------------------------------------------------------

# Run all tests (frontend + Rust)
test:
    pnpm run frontend:test
    cd src-tauri && cargo test

# Run frontend unit tests only
test-unit:
    pnpm run frontend:test

## Rust ----------------------------------------------------------------------

# Run cargo clippy
rust-lint:
    cd src-tauri && cargo clippy -- -D warnings

# Run cargo fmt
rust-format:
    cd src-tauri && cargo fmt

# Run cargo test
rust-test:
    cd src-tauri && cargo test

## CI & Setup ----------------------------------------------------------------

# Build Storybook static site
storybook-build:
    pnpm run storybook:build

# Run full CI pipeline (lint, format-check, typecheck, test, build, storybook-build)
ci: lint format-check typecheck test build storybook-build

# Install dependencies and git hooks
setup:
    pnpm run project:init
    pnpm lefthook install

# Remove build artifacts
clean:
    pnpm run clean

## Template ------------------------------------------------------------------

# Interactive project initialization (rename + bundle ID)
initialize:
    bash scripts/initialize.sh

# Non-interactive rename (PROJECT_NAME and BUNDLE_ID env vars required)
rename:
    bash scripts/rename.sh

# Check for drift against upstream template
template-check:
    bash scripts/sync-template-check

# Generate changelog from conventional commits
changelog:
    git-cliff --output CHANGELOG.md

# Bring repo up to date with upstream template (dry-run by default; --execute to run)
bring-up-to-date *args:
    bash scripts/bring_up_to_date.sh {{args}}
alias butd := bring-up-to-date

# Bring all downstream projects up to date (dry-run by default; --execute to run)
bring-up-to-date-all *args:
    bash scripts/bring_up_to_date_all.sh {{args}}
alias butda := bring-up-to-date-all

# Sync shared layer to cousin template repos (dry-run by default; --execute to run)
sync-cousins *args:
    bash scripts/sync_cousins.sh {{args}}
