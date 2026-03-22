import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _eventsCollection = 'live_events';

  // Get all events from Firestore
  Future<List<EventModel>> getAllEvents() async {
    try {
      final querySnapshot = await _firestore
          .collection(_eventsCollection)
          .orderBy('startDate', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      rethrow;
    }
  }

  // Get upcoming events (next 3 months)
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final now = DateTime.now();
      final threeMonthsLater = now.add(const Duration(days: 90));

      final querySnapshot = await _firestore
          .collection(_eventsCollection)
          .where(
            'startDate',
            isGreaterThanOrEqualTo: now.millisecondsSinceEpoch,
          )
          .where(
            'startDate',
            isLessThan: threeMonthsLater.millisecondsSinceEpoch,
          )
          .orderBy('startDate', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching upcoming events: $e');
      rethrow;
    }
  }

  // Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .get();

      if (doc.exists) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching event: $e');
      rethrow;
    }
  }

  // Add event to Firestore
  Future<void> addEvent(EventModel event) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(event.id)
          .set(event.toMap());
    } catch (e) {
      print('Error adding event: $e');
      rethrow;
    }
  }

  // Update event in Firestore
  Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(event.id)
          .update(event.toMap());
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  // Delete event from Firestore
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_eventsCollection).doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  // Batch add events to Firestore (for initial setup)
  Future<void> batchAddEvents(List<EventModel> events) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (EventModel event in events) {
        final docRef = _firestore.collection(_eventsCollection).doc(event.id);
        batch.set(docRef, event.toMap());
      }

      await batch.commit();
    } catch (e) {
      print('Error batch adding events: $e');
      rethrow;
    }
  }

  // Stream of all events
  Stream<List<EventModel>> getAllEventsStream() {
    try {
      return _firestore
          .collection(_eventsCollection)
          .orderBy('startDate', descending: false)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => EventModel.fromMap(doc.data()))
                .toList(),
          );
    } catch (e) {
      print('Error streaming events: $e');
      rethrow;
    }
  }

  // Stream of upcoming events
  Stream<List<EventModel>> getUpcomingEventsStream() {
    try {
      final now = DateTime.now();
      final threeMonthsLater = now.add(const Duration(days: 90));

      return _firestore
          .collection(_eventsCollection)
          .where(
            'startDate',
            isGreaterThanOrEqualTo: now.millisecondsSinceEpoch,
          )
          .where(
            'startDate',
            isLessThan: threeMonthsLater.millisecondsSinceEpoch,
          )
          .orderBy('startDate', descending: false)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => EventModel.fromMap(doc.data()))
                .toList(),
          );
    } catch (e) {
      print('Error streaming upcoming events: $e');
      rethrow;
    }
  }
}
