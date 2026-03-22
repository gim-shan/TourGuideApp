import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../map/models/destination_model.dart';

class ARPreviewScreen extends StatelessWidget {
  final Destination destination;

  const ARPreviewScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destination.name)),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (destination.arModelUrl.isNotEmpty) {
      return ModelViewer(
        src: destination.arModelUrl,
        alt: "A 3D model of ${destination.name}",
        ar: true,
        autoRotate: true,
        cameraControls: true,
      );
    } else if (destination.vrImageUrl.isNotEmpty) {
      return InteractiveViewer(
        child: Image.network(destination.vrImageUrl, fit: BoxFit.contain),
      );
    } else {
      return const Center(
        child: Text("No AR/VR content available for this destination."),
      );
    }
  }
}
