import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel_model.dart';

class HotelFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _hotelsCollection = 'hotels';

  // Get all hotels from Firestore
  Future<List<HotelModel>> getAllHotels() async {
    try {
      final querySnapshot = await _firestore
          .collection(_hotelsCollection)
          .orderBy('rating', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HotelModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching hotels: $e');
      rethrow;
    }
  }

  // Get hotel by ID
  Future<HotelModel?> getHotelById(String hotelId) async {
    try {
      final doc = await _firestore
          .collection(_hotelsCollection)
          .doc(hotelId)
          .get();

      if (doc.exists) {
        return HotelModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching hotel: $e');
      rethrow;
    }
  }

  // Get hotels by category
  Future<List<HotelModel>> getHotelsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_hotelsCollection)
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HotelModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching hotels by category: $e');
      rethrow;
    }
  }

  // Get featured hotels (top rated)
  Future<List<HotelModel>> getFeaturedHotels() async {
    try {
      final querySnapshot = await _firestore
          .collection(_hotelsCollection)
          .orderBy('rating', descending: true)
          .limit(5)
          .get();

      return querySnapshot.docs
          .map((doc) => HotelModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching featured hotels: $e');
      rethrow;
    }
  }

  // Add hotel to Firestore
  Future<void> addHotel(HotelModel hotel) async {
    try {
      await _firestore
          .collection(_hotelsCollection)
          .doc(hotel.id)
          .set(hotel.toMap());
    } catch (e) {
      print('Error adding hotel: $e');
      rethrow;
    }
  }

  // Update hotel in Firestore
  Future<void> updateHotel(HotelModel hotel) async {
    try {
      await _firestore
          .collection(_hotelsCollection)
          .doc(hotel.id)
          .update(hotel.toMap());
    } catch (e) {
      print('Error updating hotel: $e');
      rethrow;
    }
  }

  // Delete hotel from Firestore
  Future<void> deleteHotel(String hotelId) async {
    try {
      await _firestore.collection(_hotelsCollection).doc(hotelId).delete();
    } catch (e) {
      print('Error deleting hotel: $e');
      rethrow;
    }
  }

  // Batch add hotels to Firestore (for initial setup)
  Future<void> batchAddHotels(List<HotelModel> hotels) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (HotelModel hotel in hotels) {
        final docRef = _firestore.collection(_hotelsCollection).doc(hotel.id);
        batch.set(docRef, hotel.toMap());
      }

      await batch.commit();
    } catch (e) {
      print('Error batch adding hotels: $e');
      rethrow;
    }
  }

  // Check if hotels collection has data
  Future<bool> hasData() async {
    try {
      final querySnapshot = await _firestore
          .collection(_hotelsCollection)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking hotels data: $e');
      return false;
    }
  }

  // Stream of all hotels
  Stream<List<HotelModel>> getAllHotelsStream() {
    try {
      return _firestore
          .collection(_hotelsCollection)
          .orderBy('rating', descending: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => HotelModel.fromMap(doc.data()))
                .toList(),
          );
    } catch (e) {
      print('Error streaming hotels: $e');
      rethrow;
    }
  }
}
