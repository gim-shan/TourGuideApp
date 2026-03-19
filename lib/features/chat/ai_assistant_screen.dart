import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Local backend URL (running on this machine). Update when deploying.
  // For a REAL phone, this must be your PC's LAN IP (same Wi‑Fi),
  // e.g. http://192.168.1.26:3000/groq-generate
  //
  // You can override at build/run time:
  // flutter run --dart-define=AI_BACKEND_URL=http://<PC_LAN_IP>:3000/groq-generate
  static const String _backendUrlOverride = String.fromEnvironment(
    'AI_BACKEND_URL',
    defaultValue: '',
  );

  static String get _backendUrl {
    if (_backendUrlOverride.trim().isNotEmpty)
      return _backendUrlOverride.trim();
    if (kIsWeb) return 'http://localhost:3000/groq-generate';
    if (Platform.isAndroid) {
      // Defaulting to a common LAN IP used previously in this project.
      // Change via --dart-define when your IP changes.
      return 'http://10.121.182.41:3000/groq-generate';
    }
    return 'http://localhost:3000/groq-generate';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _callBackend(String prompt) async {
    final resp = await http.post(
      Uri.parse(_backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['reply'] as String? ?? 'No reply';
    }
    String body = resp.body;
    if (body.length > 500) body = body.substring(0, 500);
    throw Exception('Backend error ${resp.statusCode}: $body');
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;

    // Show debug info on first message
    final isFirstMessage = _messages.isEmpty;
    setState(() {
      _messages.add({'sender': 'user', 'text': text.trim()});
      _messages.add({'sender': 'assistant', 'text': '...'}); // placeholder
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await _callBackend(text.trim());
      setState(() {
        // replace last placeholder assistant message
        for (var i = _messages.length - 1; i >= 0; i--) {
          if (_messages[i]['sender'] == 'assistant' &&
              _messages[i]['text'] == '...') {
            _messages[i] = {'sender': 'assistant', 'text': reply};
            break;
          }
        }
      });
    } catch (e) {
      String errorMsg = 'Failed to get reply:\n$e';
      // Add helpful debug info on error
      if (isFirstMessage) {
        errorMsg =
            'Backend error (404): Could not connect to server.\n\n'
            'To fix this:\n'
            '1. Make sure your PC and phone are on the same WiFi\n'
            '2. Run the backend: "cd functions && npm start"\n'
            '3. Find your PC IP (run "ipconfig" on Windows)\n'
            '4. Run Flutter with: flutter run --dart-define=AI_BACKEND_URL=http://YOUR_PC_IP:3000/groq-generate\n\n'
            'Current backend: $_backendUrl\n\n'
            'Error: $e';
      }
      setState(() {
        for (var i = _messages.length - 1; i >= 0; i--) {
          if (_messages[i]['sender'] == 'assistant' &&
              _messages[i]['text'] == '...') {
            _messages[i] = {'sender': 'assistant', 'text': errorMsg};
            break;
          }
        }
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m['sender'] == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xff1b9c4d)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      decoration: InputDecoration(
                        hintText: 'Ask the assistant...',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xff1b9c4d),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.send, size: 20),
                      onPressed: () => _send(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
