import '../models/event_model.dart';
import '../services/firestore_service.dart';

class EventRepository {
  final EventFirestoreService _firestoreService = EventFirestoreService();

  // Get all events - tries Firestore first, falls back to sample data
  Future<List<EventModel>> getAllEvents() async {
    try {
      return await _firestoreService.getAllEvents();
    } catch (e) {
      print('Firestore unavailable, using sample data: $e');
      return EventModel.getAllEvents();
    }
  }

  // Get upcoming events - tries Firestore first, falls back to sample data
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      return await _firestoreService.getUpcomingEvents();
    } catch (e) {
      print('Firestore unavailable, using sample data: $e');
      return EventModel.getUpcomingEvents();
    }
  }

  // Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      return await _firestoreService.getEventById(eventId);
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  // Add event
  Future<void> addEvent(EventModel event) async {
    await _firestoreService.addEvent(event);
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    await _firestoreService.updateEvent(event);
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteEvent(eventId);
  }

  // Initialize database with sample events
  Future<void> initializeSampleEvents() async {
    try {
      await _firestoreService.batchAddEvents(EventModel.getSampleEvents());
      print('Sample events initialized successfully');
    } catch (e) {
      print('Error initializing sample events: $e');
      rethrow;
    }
  }

  // Stream of all events
  Stream<List<EventModel>> getAllEventsStream() {
    return _firestoreService.getAllEventsStream();
  }

  // Stream of upcoming events
  Stream<List<EventModel>> getUpcomingEventsStream() {
    return _firestoreService.getUpcomingEventsStream();
  }
}
