import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ArPreviewListScreen extends StatelessWidget {
  const ArPreviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      {
        'name': 'Sigiriya',
        'image': 'assets/images/sigiriya.jpg',
        'model': 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        'sketchfab':
            'https://sketchfab.com/models/8c85ec4fcbe74fbaae722d8cbb1241c5',
      },
      {
        'name': 'Galle Fort',
        'image': 'assets/images/gallefort.jpg',
        'model':
            'https://modelviewer.dev/shared-assets/models/FlightHelmet.glb',
        'panorama':
            'https://www.p4panorama.com/panos/Galle-Sri-Lanka-360-degree-virtual-reality-tour/',
      },
      {
        'name': 'Kandy Temple',
        'image': 'assets/images/kandy.jpg',
        'model':
            'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
        'panorama':
            'https://www.p4panorama.com/panos/temple-of-the-tooth-kandy-sri-lanka-360-virtual-reality-tour/',
      },
      {
        'name': 'Jaffna',
        'image': 'assets/images/jaffna.jpg',
        'model': 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AR Previews')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: destinations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final d = destinations[index];
          return Card(
            child: InkWell(
              onTap: () {
                final panoramaUrl = d['panorama']?.toString();
                if (panoramaUrl != null && panoramaUrl.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PanoramaViewerScreen(
                        imageUrl: panoramaUrl,
                        title: d['name'].toString(),
                      ),
                    ),
                  );
                  return;
                }

                final sketchfab = d['sketchfab']?.toString();
                if (sketchfab != null && sketchfab.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SketchfabViewerScreen(url: sketchfab),
                    ),
                  );
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArModelViewerScreen(
                      title: d['name'].toString(),
                      imageAsset: d['image'].toString(),
                      modelUrl: d['model'].toString(),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(6),
                      ),
                      child: Image.asset(
                        d['image'] as String,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      d['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ArModelViewerScreen extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String modelUrl;

  const ArModelViewerScreen({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.modelUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              src: modelUrl,
              alt: title,
              ar: true,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ModelViewer handles AR activation on supported platforms.
                    },
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text('Open AR Preview'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SketchfabViewerScreen extends StatefulWidget {
  final String url;

  const SketchfabViewerScreen({super.key, required this.url});

  @override
  State<SketchfabViewerScreen> createState() => _SketchfabViewerScreenState();
}

class _SketchfabViewerScreenState extends State<SketchfabViewerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    final embedUrl = _toEmbedUrl(widget.url);
    _controller.loadRequest(Uri.parse(embedUrl));
  }

  String _toEmbedUrl(String url) {
    // Convert sketchfab model URL to its embed URL
    // Example: https://sketchfab.com/models/<id> -> https://sketchfab.com/models/<id>/embed
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments[0] == 'models') {
      final id = segments[1];
      return 'https://sketchfab.com/models/$id/embed';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sigiriya (Sketchfab)')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class PanoramaViewerScreen extends StatelessWidget {
  final String imageUrl;
  final String title;

  const PanoramaViewerScreen({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl);
    final isDirectImage =
        uri != null &&
        (uri.path.endsWith('.jpg') ||
            uri.path.endsWith('.jpeg') ||
            uri.path.endsWith('.png'));

    if (!isDirectImage) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse(imageUrl));

      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: WebViewWidget(controller: controller),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PanoramaViewer(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
