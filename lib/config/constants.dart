// App constants
// FILE: lib/config/constants.dart
// PURPOSE: App-wide constants

class AppConstants {
  // App Info
  static const String appName = 'StepUp Sneakers';
  static const String appVersion = '1.0.0';

  // Colors
  static const int primaryColor = 0xFF000000;
  static const int backgroundColor = 0xFFF8F9FA;
  static const int cardColor = 0xFFFFFFFF;
  static const int borderColor = 0xFFE5E7EB;
  static const int textPrimary = 0xFF000000;
  static const int textSecondary = 0xFF6B7280;

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Image
  static const double maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 80;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // Pagination
  static const int productsPerPage = 20;

  // Placeholders
  static const String placeholderImage = 'https://via.placeholder.com/300x300.png?text=No+Image';

  // Admin Email Pattern
  static const String adminEmailPattern = '@admin.com';

  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String unexpectedError = 'An unexpected error occurred. Please try again.';
  static const String noDataFound = 'No data found.';
}
