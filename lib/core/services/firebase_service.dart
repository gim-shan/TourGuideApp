import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/map/models/destination_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Destination>> getDestinations() {
    return _db.collection('destinations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Destination.fromFirestore(doc)).toList();
    });
  }
}
