import 'package:hidmo_app/features/tourist/tour_packages/services/tour_package_service.dart';

/// Database initializer for tour packages
/// Initializes tour packages in Firestore when the app starts
class TourPackageDatabaseInitializer {
  static final TourPackageService _service = TourPackageService();
  static bool _initialized = false;

  /// Initialize the tour packages database with predefined data
  static Future<void> initializeDatabase() async {
    if (_initialized) return;

    try {
      print('Initializing Tour Packages database...');
      await _service.initializePackages();
      _initialized = true;
      print('Tour Packages database initialized successfully!');
    } catch (e) {
      print('Failed to initialize Tour Packages database: $e');
      // Don't throw - let app continue even if initialization fails
    }
  }

  /// Check if database has been initialized
  static bool get isInitialized => _initialized;

  /// Reset initialization flag (for testing)
  static void resetInitialization() {
    _initialized = false;
  }
}
