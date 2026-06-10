# Changelog

## 1.2.0

### Added
- Custom discord role ping (via .env ROLE_ID)

## 1.1.0

### Added
- Added image description label to Dockerfile for better container registry visibility.

## 1.0.0

### Added
- **Modular Architecture**: Complete refactor into specialized services (Epic, Discord, Storage).
- **Dual Categorization**: Separate notifications for "Currently Free" and "Upcoming" games.
- **Rich Discord UI**: Enhanced embeds with game images, original prices, and status-specific colors (Green/Blue).
- **Smart Persistence**: JSON-based storage to prevent duplicate notifications, even after restarts.
- **Status Transition Support**: Automatic re-notification when a game moves from "Upcoming" to "Currently Free".
- **Advanced Static Analysis**: Enforced strict typing and SOLID-inspired linting rules for high code quality.
- **Docker Support**: Ultra-lightweight image based on `scratch` with GHCR.io integration.
- **Environment Support**: Configuration via `.env` files or system environment variables.
- **Comprehensive Testing**: Added unit tests for models and live API integration tests.

### Fixed
- Improved environment variable detection for more robust configuration.
- Fixed image extraction from Epic Games Store metadata.
- Optimized Docker build context using `.dockerignore`.
