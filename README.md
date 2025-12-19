# Quick Shop - Flutter E-commerce Application

A complete Flutter e-commerce application built with Clean Architecture, BLoC pattern, and Firebase authentication.

## Features

- 🔐 **Firebase Email & Password Authentication** - Secure user authentication
- 📦 **Product Listing** - Browse products from FakeStore API
- 🛒 **Shopping Cart** - Add, remove, and update cart items
- 💳 **Checkout Flow** - Complete checkout process
- 🏗️ **Clean Architecture** - Well-structured, maintainable codebase
- 📱 **BLoC State Management** - Reactive state management with flutter_bloc

## Architecture

This project follows **Clean Architecture** principles with three main layers:

### 1. Presentation Layer
- **BLoC**: State management using flutter_bloc
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

### 2. Domain Layer
- **Entities**: Business objects
- **Use Cases**: Business logic
- **Repository Interfaces**: Abstract data contracts

### 3. Data Layer
- **Data Sources**: Remote (API) and Local (SharedPreferences) data sources
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete implementations of domain repositories

### Data Flow

```
UI → BLoC → UseCase → Repository → DataSource → API/Storage
```

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/                 # API endpoints, app constants
│   ├── error/                     # Error handling (exceptions, failures)
│   ├── network/                   # API client, network info
│   ├── utils/                     # Validators, extensions
│   ├── theme/                     # App theme and colors
│   └── injection/                 # Dependency injection setup
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer (datasources, models, repositories)
│   │   ├── domain/                # Domain layer (entities, usecases, repositories)
│   │   └── presentation/          # Presentation layer (bloc, pages, widgets)
│   │
│   ├── products/                  # Product listing feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── cart/                      # Cart & Checkout feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── main.dart                      # App entry point
└── app.dart                       # Root app widget with routing
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code with Flutter extensions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd quick_shop
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable **Email/Password** authentication in Firebase Console
3. Download configuration files:
   - **Android**: Download `google-services.json` and place it in `android/app/`
   - **iOS**: Download `GoogleService-Info.plist` and place it in `ios/Runner/`
4. The Firebase configuration is already set up in the Android build files

### 4. Generate Code (Optional)

If you modify JSON serializable models, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the Application

```bash
flutter run
```

## Dependencies

### Core Dependencies

- `flutter_bloc: ^8.1.3` - BLoC state management
- `equatable: ^2.0.5` - Value equality
- `firebase_core: ^2.24.2` - Firebase initialization
- `firebase_auth: ^4.15.3` - Firebase authentication
- `dio: ^5.4.0` - HTTP client
- `get_it: ^7.6.4` - Dependency injection
- `dartz: ^0.10.1` - Functional programming (Either type)
- `go_router: ^13.0.0` - Navigation
- `shared_preferences: ^2.2.2` - Local storage
- `cached_network_image: ^3.3.1` - Image caching
- `connectivity_plus: ^5.0.2` - Network connectivity
- `json_annotation: ^4.8.1` - JSON serialization

### Dev Dependencies

- `build_runner: ^2.4.7` - Code generation
- `json_serializable: ^6.7.1` - JSON code generation

## API

The application uses the [FakeStore API](https://fakestoreapi.com) for product data:

- Base URL: `https://fakestoreapi.com`
- Products Endpoint: `/products`
- Product Details: `/products/{id}`

## Features Implementation

### Authentication

- **Sign In**: Email and password authentication
- **Sign Up**: User registration with email validation
- **Sign Out**: User logout functionality
- **Auth State Management**: BLoC handles authentication state

### Products

- **Product Listing**: Grid view of all products
- **Product Details**: Detailed product view with add to cart
- **Image Loading**: Cached network images for better performance

### Cart

- **Add to Cart**: Add products with quantity
- **Update Quantity**: Increase/decrease item quantity
- **Remove Items**: Remove items from cart
- **Cart Persistence**: Cart data stored locally using SharedPreferences
- **Checkout**: Order summary and checkout flow

## State Management

The app uses **BLoC (Business Logic Component)** pattern:

- **Events**: User actions (e.g., `SignInRequested`, `LoadProducts`)
- **States**: UI states (e.g., `AuthLoading`, `ProductsLoaded`)
- **Bloc**: Business logic that transforms events into states

## Error Handling

- **Custom Exceptions**: ServerException, NetworkException, AuthException, CacheException
- **Failure Classes**: ServerFailure, NetworkFailure, AuthFailure, CacheFailure
- **Error Messages**: User-friendly error messages displayed via SnackBar

## Navigation

The app uses `go_router` for navigation with the following routes:

- `/login` - Login page
- `/register` - Registration page
- `/products` - Product listing
- `/product-detail?id={id}` - Product details
- `/cart` - Shopping cart
- `/checkout` - Checkout page

## Testing

The project structure supports testing at all layers:

- **Unit Tests**: Test use cases and business logic
- **BLoC Tests**: Test state management
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows

## Future Enhancements

- [ ] User profile management
- [ ] Order history
- [ ] Product search and filtering
- [ ] Product categories
- [ ] Payment integration
- [ ] Push notifications
- [ ] Dark mode support
- [ ] Internationalization (i18n)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Author

Built with ❤️ using Flutter
