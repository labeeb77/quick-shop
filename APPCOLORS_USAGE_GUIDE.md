# AppColors Usage Guide

## Quick Reference

This guide shows how to use the `AppColors` class for consistent theming throughout the app.

## Import

```dart
import 'package:quick_shop/core/theme/app_colors.dart';
```

## Available Colors

### Auth Screen Colors
```dart
AppColors.authPrimary              // #5D5FEF - Purple primary button
AppColors.authInputBackground      // #F5F5F5 - Light gray input fields
AppColors.authSecondaryBackground  // #F5F5F5 - Gray button background
AppColors.authBorder               // #E0E0E0 - Border for outlined buttons
```

### Text Colors
```dart
AppColors.textPrimary    // #000000 - Primary text (black)
AppColors.textSecondary  // #757575 - Secondary text (gray)
AppColors.textHint       // #9E9E9E - Hint/placeholder text
AppColors.textWhite      // #FFFFFF - White text
```

### Common Colors
```dart
AppColors.white        // #FFFFFF - White
AppColors.black        // #000000 - Black
AppColors.transparent  // Transparent
```

### Theme Colors (Original)
```dart
AppColors.primary      // #6200EE - Material primary
AppColors.primaryDark  // #3700B3 - Material primary dark
AppColors.secondary    // #03DAC6 - Material secondary
AppColors.error        // #B00020 - Error color
AppColors.background   // #F5F5F5 - Background
AppColors.surface      // #FFFFFF - Surface
```

## Usage Examples

### Text Widget
```dart
Text(
  'Welcome back!',
  style: TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
  ),
)
```

### Container Background
```dart
Container(
  color: AppColors.authInputBackground,
  child: TextField(...),
)
```

### Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.authPrimary,
    foregroundColor: AppColors.textWhite,
  ),
  child: Text('Sign In'),
)
```

### Icon
```dart
Icon(
  Icons.visibility_off,
  color: AppColors.textHint,
)
```

### Scaffold
```dart
Scaffold(
  backgroundColor: AppColors.white,
  appBar: AppBar(
    backgroundColor: AppColors.white,
  ),
)
```

### Border
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.authBorder),
  ),
)
```

## Best Practices

1. **Always use AppColors** instead of hardcoded color values
2. **Never use** `Colors.black`, `Colors.white`, etc. directly - use `AppColors.black`, `AppColors.white`
3. **For new colors**, add them to `app_colors.dart` first, then use them
4. **Group related colors** with descriptive prefixes (e.g., `auth*`, `text*`)
5. **Document color usage** with comments in `app_colors.dart`

## Adding New Colors

When adding new colors to the app:

1. Open `lib/core/theme/app_colors.dart`
2. Add the color constant with a descriptive name:
   ```dart
   static const Color myNewColor = Color(0xFF123456);
   ```
3. Add a comment explaining where it's used:
   ```dart
   static const Color myNewColor = Color(0xFF123456); // Used for XYZ feature
   ```
4. Use it in your widgets:
   ```dart
   color: AppColors.myNewColor
   ```

## Color Naming Conventions

- Use descriptive names: `authPrimary` instead of `purple`
- Use prefixes for grouping: `text*`, `auth*`, `button*`
- Use semantic names: `error` instead of `red`
- Be consistent with existing naming patterns

## Benefits

✅ **Centralized management** - Change colors in one place  
✅ **Type safety** - Compile-time checking  
✅ **Better readability** - `AppColors.authPrimary` vs `Color(0xFF5D5FEF)`  
✅ **Easy theming** - Support for dark mode, brand changes  
✅ **Consistency** - Same colors across the app  
✅ **Maintainability** - Easy to update and refactor  
