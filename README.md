# Quick Shop

A Flutter e-commerce application built with Clean Architecture and BLoC pattern.

## Features

- Firebase Authentication (Email/Password)
- Product Listing & Search
- Shopping Cart Management
- Checkout Flow

## Architecture

This project follows **Clean Architecture** with three main layers:

### Layer Structure

```
Presentation Layer (UI)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (Data Sources)
```

### Layers Explained

**Presentation Layer**
- UI components (Pages, Widgets)
- BLoC for state management
- Handles user interactions

**Domain Layer**
- Business logic (Use Cases)
- Entity models
- Repository interfaces

**Data Layer**
- Remote data sources (API)
- Local data sources (SharedPreferences)
- Data models and repository implementations

### State Management

Uses **BLoC Pattern**:
- **Events**: User actions (e.g., `LoadProducts`, `SignInRequested`)
- **States**: UI states (e.g., `ProductListLoaded`, `AuthLoading`)
- **Bloc**: Processes events and emits states

### Project Structure

```
lib/
├── core/                    # Shared utilities
│   ├── constants/          # API endpoints, constants
│   ├── error/              # Error handling
│   ├── network/            # API client
│   ├── theme/             # App theme
│   ├── utils/             # Helpers, validators
│   └── injection/         # Dependency injection
│
└── features/               # Feature modules
    ├── auth/              # Authentication
    ├── products/          # Products
    └── cart/             # Shopping cart
        ├── data/         # Data layer
        ├── domain/       # Domain layer
        └── presentation/ # Presentation layer
```

## Setup

### Prerequisites

- Flutter SDK 3.10.1+
- Firebase account

### Installation

1. **Clone repository**
```bash
git clone <repository-url>
cd quick_shop
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Create project at [Firebase Console](https://console.firebase.google.com)
   - Enable Email/Password authentication
   - Download `google-services.json` → place in `android/app/`
   - Download `GoogleService-Info.plist` → place in `ios/Runner/`

4. **Run application**
   ```bash
   flutter run
   ```

### Code Generation

For JSON serialization:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Dependencies

- `flutter_bloc` - State management
- `firebase_auth` - Authentication
- `dio` - HTTP client
- `get_it` - Dependency injection
- `go_router` - Navigation
- `shared_preferences` - Local storage
- `cached_network_image` - Image caching

## API

Uses [FakeStore API](https://fakestoreapi.com):
- Base URL: `https://fakestoreapi.com`
- Products: `/products`
- Product Details: `/products/{id}`

## Routes

- `/splash` - Splash screen
- `/login` - Login page
- `/register` - Registration
- `/home` - Product listing
- `/search` - Search page
- `/product-detail?id={id}` - Product details
- `/cart` - Shopping cart
- `/checkout` - Checkout
- `/profile` - User profile

## Development

### Run Tests
```bash
flutter test
```

### Build
```bash
flutter build apk      # Android
flutter build ios      # iOS
```
