import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = '';
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Sinhala';
  bool _isTranslating = false;

  // Language codes for MyMemory API
  final Map<String, String> _languageCodes = {
    'English': 'en',
    'Sinhala': 'si',
    'Tamil': 'ta',
    'French': 'fr',
    'German': 'de',
    'Spanish': 'es',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Hindi': 'hi',
    'Arabic': 'ar',
    'Russian': 'ru',
    'Dutch': 'nl',
    'Thai': 'th',
    'Vietnamese': 'vi',
    'Indonesian': 'id',
    'Malay': 'ms',
  };

  final List<String> _languages = [
    'English',
    'Sinhala',
    'Tamil',
    'French',
    'German',
    'Spanish',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Hindi',
    'Arabic',
    'Russian',
    'Dutch',
    'Thai',
    'Vietnamese',
    'Indonesian',
    'Malay',
  ];

  // MyMemory Translation API (Free, 1000 chars/day without key)
  Future<String> _translateWithMyMemory(
    String text,
    String source,
    String target,
  ) async {
    try {
      final sourceCode = _languageCodes[source] ?? 'en';
      final targetCode = _languageCodes[target] ?? 'si';

      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=$sourceCode|$targetCode',
      );

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timed out'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['responseStatus'] == 200) {
          return data['responseData']['translatedText'] ??
              'No translation found';
        } else {
          return 'Translation error: ${data['responseDetails']}';
        }
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> _performTranslation() async {
    if (_inputController.text.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final result = await _translateWithMyMemory(
        _inputController.text,
        _sourceLanguage,
        _targetLanguage,
      );

      if (mounted) {
        setState(() {
          _translatedText = result;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _translatedText = 'Translation failed. Please try again.';
          _isTranslating = false;
        });
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;

      // Swap texts as well
      final tempText = _inputController.text;
      _inputController.text = _translatedText;
      _translatedText = tempText;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        backgroundColor: const Color(0xff1b9c4d),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1b9c4d), Color(0xff0e5a3c)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Language selector row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _LanguageDropdown(
                        label: 'From',
                        value: _sourceLanguage,
                        languages: _languages,
                        onChanged: (value) {
                          setState(() {
                            _sourceLanguage = value!;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _swapLanguages,
                      icon: const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    Expanded(
                      child: _LanguageDropdown(
                        label: 'To',
                        value: _targetLanguage,
                        languages: _languages,
                        onChanged: (value) {
                          setState(() {
                            _targetLanguage = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Translation cards
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Input text field
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: 'Enter text to translate...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xff1b9c4d),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xff1b9c4d),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Translate button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isTranslating
                                ? null
                                : _performTranslation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1b9c4d),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isTranslating
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Translate',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Translated text field
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xfff5f5f5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xff1b9c4d).withOpacity(0.3),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                _translatedText.isEmpty
                                    ? 'Translation will appear here...'
                                    : _translatedText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _translatedText.isEmpty
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  const _LanguageDropdown({
    required this.label,
    required this.value,
    required this.languages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xff1b9c4d)),
            items: languages.map((lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Text(
                  lang,
                  style: const TextStyle(
                    color: Color(0xff0e5a3c),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
