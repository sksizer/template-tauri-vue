.DEFAULT_GOAL := help

.PHONY: help dev build build-debug lint lint-fix format format-check typecheck \
        test test-unit rust-lint rust-format rust-test ci setup clean \
        storybook storybook-build ports initialize rename \
        full-check full-write changelog \
        template-check bring-up-to-date bring-up-to-date-all sync-cousins

## Development ---------------------------------------------------------------

help: ## Show this help message
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Development:"
	@echo "  dev            Run tauri dev server (auto-assigned port)"
	@echo "  build          Build for production"
	@echo "  build-debug    Build with debug symbols"
	@echo "  storybook      Launch Storybook dev server (auto-assigned port)"
	@echo "  ports          Show auto-assigned port block for this worktree"
	@echo ""
	@echo "Linting & Formatting:"
	@echo "  lint           Run all linters (frontend + Rust)"
	@echo "  lint-fix       Auto-fix lint issues"
	@echo "  format         Format all code"
	@echo "  format-check   Check formatting without changes"
	@echo "  typecheck      Run frontend type checking"
	@echo "  full-check     Run all code checks (lint + format-check + typecheck)"
	@echo "  full-write     Auto-fix all formatting (frontend + Rust)"
	@echo ""
	@echo "Testing:"
	@echo "  test           Run all tests (frontend + Rust)"
	@echo "  test-unit      Run frontend unit tests only"
	@echo ""
	@echo "Rust:"
	@echo "  rust-lint      Run cargo clippy"
	@echo "  rust-format    Run cargo fmt"
	@echo "  rust-test      Run cargo test"
	@echo ""
	@echo "CI & Setup:"
	@echo "  ci             Run full CI pipeline (lint, format-check, typecheck, test, build, storybook-build)"
	@echo "  storybook-build Build Storybook static site"
	@echo "  setup          Install dependencies and git hooks"
	@echo "  clean          Remove build artifacts"
	@echo ""
	@echo "  changelog      Generate changelog from conventional commits"
	@echo ""
	@echo "Template:"
	@echo "  initialize     Interactive project initialization (rename + bundle ID)"
	@echo "  rename         Non-interactive rename (requires PROJECT_NAME, BUNDLE_ID env vars)"
	@echo "  template-check       Check for drift against upstream template"
	@echo "  bring-up-to-date     Sync with upstream template (dry-run default)"
	@echo "  bring-up-to-date-all Sync all downstream projects (dry-run default)"
	@echo "  sync-cousins         Sync shared layer to cousin templates (dry-run default)"
	@echo ""

dev: ## Run tauri dev server
	pnpm tauri dev

build: ## Build for production
	pnpm tauri build

build-debug: ## Build with debug symbols
	pnpm tauri build --debug

storybook: ## Launch Storybook dev server
	pnpm run storybook

ports: ## Show auto-assigned port block for this worktree
	@scripts/dev-port.sh --all

## Linting & Formatting ------------------------------------------------------

lint: ## Run all linters (frontend + Rust)
	pnpm run frontend:lint
	cd src-tauri && cargo clippy -- -D warnings

lint-fix: ## Auto-fix lint issues
	cd src-vue && pnpm eslint . --fix
	cd src-tauri && cargo clippy --fix --allow-dirty

format: ## Format all code
	pnpm run format

format-check: ## Check formatting without changes
	pnpm run format:check
	cd src-tauri && cargo fmt -- --check

typecheck: ## Run frontend type checking
	pnpm run frontend:typecheck

full-check: lint format-check typecheck ## Run all code checks

full-write: ## Auto-fix all formatting (frontend + Rust)
	pnpm run format
	cd src-tauri && cargo fmt --all

## Testing -------------------------------------------------------------------

test: ## Run all tests (frontend + Rust)
	pnpm run frontend:test
	cd src-tauri && cargo test

test-unit: ## Run frontend unit tests only
	pnpm run frontend:test

## Rust ----------------------------------------------------------------------

rust-lint: ## Run cargo clippy
	cd src-tauri && cargo clippy -- -D warnings

rust-format: ## Run cargo fmt
	cd src-tauri && cargo fmt

rust-test: ## Run cargo test
	cd src-tauri && cargo test

## CI & Setup ----------------------------------------------------------------

storybook-build: ## Build Storybook static site
	pnpm run storybook:build

ci: lint format-check typecheck test build storybook-build ## Run full CI pipeline

setup: ## Install dependencies and git hooks
	pnpm run project:init
	pnpm lefthook install

clean: ## Remove build artifacts
	pnpm run clean

## Template ------------------------------------------------------------------

initialize: ## Interactive project initialization
	bash scripts/initialize.sh

rename: ## Non-interactive rename (PROJECT_NAME and BUNDLE_ID env vars required)
	bash scripts/rename.sh

template-check: ## Check for drift against upstream template
	bash scripts/sync-template-check

changelog: ## Generate changelog from conventional commits
	git-cliff --output CHANGELOG.md

bring-up-to-date: ## Sync with upstream template (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date.sh $(ARGS)

bring-up-to-date-all: ## Sync all downstream projects (dry-run default; pass ARGS="--execute" to run)
	bash scripts/bring_up_to_date_all.sh $(ARGS)

sync-cousins: ## Sync shared layer to cousin templates (dry-run default; pass ARGS="--execute" to run)
	bash scripts/sync_cousins.sh $(ARGS)
