import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hidmo_app/core/services/firebase_service.dart';
import '../models/destination_model.dart';
import '../../ar_vr/screens/ar_preview_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final Set<Marker> _markers = {};

  static final CameraPosition _sriLanka = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 7.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Sri Lanka')),
      body: StreamBuilder<List<Destination>>(
        stream: _firebaseService.getDestinations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _generateMarkers(snapshot.data!);

          return GoogleMap(
            initialCameraPosition: _sriLanka,
            markers: _markers,
            onMapCreated: (controller) {},
            myLocationEnabled: true,
          );
        },
      ),
    );
  }

  void _generateMarkers(List<Destination> destinations) {
    _markers.clear();
    for (var destination in destinations) {
      _markers.add(
        Marker(
          markerId: MarkerId(destination.id),
          position: destination.location,
          infoWindow: InfoWindow(
            title: destination.name,
            snippet: 'Tap to view in AR/VR',
            onTap: () => _navigateToAR(destination),
          ),
        ),
      );
    }
  }

  void _navigateToAR(Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARPreviewScreen(destination: destination),
      ),
    );
  }
}
