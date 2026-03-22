/// Database initializer for guides
/// Note: We now use dummy guides in-memory instead of adding to Firestore
class GuideDatabaseInitializer {
  static bool _initialized = false;

  /// Initialize the guides database
  /// (no longer adds to Firestore - uses in-memory dummy guides instead)
  static Future<void> initializeDatabase() async {
    if (_initialized) return;
    _initialized = true;
    print('Guides database initialized (using in-memory dummy guides)');
  }

  /// Check if database has been initialized
  static bool get isInitialized => _initialized;

  /// Reset initialization flag (for testing)
  static void resetInitialization() {
    _initialized = false;
  }
}
