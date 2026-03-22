import '../models/event_model.dart';
import '../repositories/event_repository.dart';

class EventDatabaseInitializer {
  static final EventRepository _repository = EventRepository();
  static bool _initialized = false;

  /// Initialize the live events database with sample data
  static Future<void> initializeDatabase() async {
    if (_initialized) return;

    try {
      print('Initializing Live Events database...');
      await _repository.initializeSampleEvents();
      _initialized = true;
      print('Live Events database initialized successfully!');
    } catch (e) {
      print('Error initializing Live Events database: $e');
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
