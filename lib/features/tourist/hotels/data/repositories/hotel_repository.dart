import '../models/hotel_model.dart';
import '../services/hotel_firestore_service.dart';

class HotelRepository {
  final HotelFirestoreService _firestoreService = HotelFirestoreService();

  // Get all hotels - tries Firestore first, falls back to sample data
  Future<List<HotelModel>> getAllHotels() async {
    try {
      return await _firestoreService.getAllHotels();
    } catch (e) {
      print('Firestore unavailable, using sample data: $e');
      return HotelModel.getAllHotels();
    }
  }

  // Get hotel by ID
  Future<HotelModel?> getHotelById(String hotelId) async {
    try {
      return await _firestoreService.getHotelById(hotelId);
    } catch (e) {
      print('Error fetching hotel: $e');
      // Fallback to sample data
      final hotels = HotelModel.getAllHotels();
      try {
        return hotels.firstWhere((h) => h.id == hotelId);
      } catch (_) {
        return null;
      }
    }
  }

  // Get hotels by category
  Future<List<HotelModel>> getHotelsByCategory(String category) async {
    try {
      return await _firestoreService.getHotelsByCategory(category);
    } catch (e) {
      print('Firestore unavailable, using sample data: $e');
      return HotelModel.getHotelsByCategory(category);
    }
  }

  // Get featured hotels (top rated)
  Future<List<HotelModel>> getFeaturedHotels() async {
    try {
      return await _firestoreService.getFeaturedHotels();
    } catch (e) {
      print('Firestore unavailable, using sample data: $e');
      return HotelModel.getFeaturedHotels();
    }
  }

  // Add hotel
  Future<void> addHotel(HotelModel hotel) async {
    await _firestoreService.addHotel(hotel);
  }

  // Update hotel
  Future<void> updateHotel(HotelModel hotel) async {
    await _firestoreService.updateHotel(hotel);
  }

  // Delete hotel
  Future<void> deleteHotel(String hotelId) async {
    await _firestoreService.deleteHotel(hotelId);
  }

  // Initialize database with sample hotels
  Future<void> initializeSampleHotels() async {
    try {
      // Check if data already exists
      final hasData = await _firestoreService.hasData();
      if (hasData) {
        print('Hotels already initialized in Firestore');
        return;
      }

      await _firestoreService.batchAddHotels(HotelModel.getSampleHotels());
      print('Sample hotels initialized successfully');
    } catch (e) {
      print('Error initializing sample hotels: $e');
      rethrow;
    }
  }

  // Stream of all hotels
  Stream<List<HotelModel>> getAllHotelsStream() {
    return _firestoreService.getAllHotelsStream();
  }

  // Check if hotels data exists in Firestore
  Future<bool> hasData() async {
    try {
      return await _firestoreService.hasData();
    } catch (e) {
      print('Error checking hotels data: $e');
      return false;
    }
  }
}
