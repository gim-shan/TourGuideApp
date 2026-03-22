import '../repositories/hotel_repository.dart';

class HotelDatabaseInitializer {
  static final HotelRepository _repository = HotelRepository();
  static bool _initialized = false;

  /// Initialize the hotels database with sample data
  static Future<void> initializeDatabase() async {
    if (_initialized) return;

    try {
      print('Initializing Hotels database...');
      await _repository.initializeSampleHotels();
      _initialized = true;
      print('Hotels database initialized successfully!');
    } catch (e) {
      print('Error initializing Hotels database: $e');
      print('Using fallback sample data');
    }
  }

  /// Check if database has been initialized
  static bool get isInitialized => _initialized;

  /// Reset initialization flag (for testing)
  static void resetInitialization() {
    _initialized = false;
  }
}
