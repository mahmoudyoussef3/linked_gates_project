# Core Module

This folder contains app-wide building blocks shared across all features.

## Responsibilities

- Dependency injection and bootstrapping (`di/`)
- Networking setup (`network/`)
- Shared UI system (`styles/`, `widgets/`)
- Reusable helpers and constants (`utils/`, `extensions/`)
- Error primitives (`error/`)

## Notes

- Keep `core` framework-agnostic where possible.
- Avoid feature-specific business logic in this module.
