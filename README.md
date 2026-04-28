# Linked Gates Project

A production-style Flutter shopping app focused on a clean architecture flow:
**Products (Home)** -> **Product Details** -> **Cart**.

The app includes:
- Network-first product loading with local caching fallback
- Responsive UI with grid/list product layouts
- Product details with size and quantity selection
- Cart management with live totals
- Native splash screen and launcher icon support for Android and iOS

---

## Features

- **Products home screen**
  - Grid/List toggle
  - Favorites state
  - Cart badge in app bar
  - Double-back exit feedback (toast)
- **Product details**
  - Hero image transition
  - Inline quantity counter
  - Size selection
  - Add-to-cart flow with styled snackbar CTA
- **Cart**
  - Quantity controls
  - Item removal
  - Total price calculation
- **UX polish**
  - Shimmer placeholders (instead of spinners)
  - Custom transitions between screens
  - Centralized color and typography system

---

## Tech Stack

- **Framework:** Flutter (Material 3)
- **State Management:** Provider (`ChangeNotifier`, `Selector`, `Consumer`)
- **Dependency Injection:** GetIt
- **Networking:** Dio + Retrofit
- **Persistence:** Hive / Hive Flutter
- **UI Utilities:** Flutter ScreenUtil, Cached Network Image, Shimmer, Fluttertoast
- **Code Generation:** build_runner, json_serializable, retrofit_generator
- **Assets Tooling:** flutter_native_splash, flutter_launcher_icons

---

## Project Structure

```text
lib/
  core/
    di/                 # service locator and dependency wiring
    error/              # exceptions/failures
    network/            # Dio client
    styles/             # app theme, colors, text styles
    utils/              # constants, helpers
    widgets/            # shared UI widgets (snackbar, shimmer, image, etc.)
  features/
    products/
      data/             # models, data sources, repository implementation
      domain/           # entities, repository contract, use cases
      presentation/     # screens, providers, UI widgets
    cart/
      presentation/     # cart screen
  app_router.dart       # named routes + transitions + provider injection
  main.dart             # app entrypoint
```

---

## Architecture Overview

The project follows a practical layered style inside features:

- **Data layer**
  - Calls remote API through Retrofit (`ProductApiService`)
  - Reads/writes local cache with Hive
  - Implements repository contract
- **Domain layer**
  - Defines entities and use-cases (e.g. `GetProductsUseCase`)
- **Presentation layer**
  - Uses Providers for UI state and business interaction
  - Screens consume state via `Selector`/`Consumer` for efficient rebuilds

### Data Flow (Products)
1. UI triggers `ProductProvider.loadProducts()`
2. Use case requests products from repository
3. Repository checks local cache (with TTL)
4. If cache is stale/missing, fetches from API and caches result
5. Provider exposes mapped state to UI

---

## Routing

Defined in `lib/app_router.dart`:

- `/products` (home)
- `/products/details`
- `/cart`

The router also:
- Validates route arguments
- Injects required providers per route
- Applies custom fade + slide page transitions

---

## Getting Started

### Prerequisites

- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Xcode (for iOS builds on macOS)
- Android Studio / Android SDK (for Android builds)

### Installation

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run tests

```bash
flutter test
```

### Static analysis

```bash
flutter analyze
```

---

## Code Generation

This project uses generated files for Retrofit and JSON serialization.
When models or API interfaces change, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Native Splash

Configuration file: `flutter_native_splash.yaml`

Regenerate splash assets:

```bash
dart run flutter_native_splash:create
```

---

## Launcher Icons

Configured in `pubspec.yaml` under `flutter_launcher_icons`.

Regenerate icons for Android + iOS:

```bash
dart run flutter_launcher_icons
```

---

## Design System Notes

- Colors: `lib/core/styles/app_colors.dart`
- Typography: `lib/core/styles/app_text_styles.dart`
- Theme: `lib/core/styles/app_theme.dart`
- Reusable feedback/snackbar: `lib/core/widgets/app_snackbar.dart`
- Reusable image with shimmer placeholder: `lib/core/widgets/app_network_image.dart`

---

## Current Scope

This app intentionally focuses on three core screens:
- Products (Home)
- Product Details
- Cart

It is a strong base for adding authentication, checkout/payment, order history, and profile flows later.

---

## License

This project is private/internal unless you choose to add an open-source license.
