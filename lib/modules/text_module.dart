import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mojitext_v2/services/api_service.dart';

class TextModule extends StatefulWidget {
  const TextModule({super.key});

  @override
  State<TextModule> createState() => _TextModuleState();
}

class _TextModuleState extends State<TextModule> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  String? _dominantEmotion;
  Map<String, dynamic> _emotionResults = {};
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  void _onTapDown(_) => _animationController.forward();
  void _onTapUp(_) => _animationController.reverse();

  Future<void> _analyzeText() async {
    if (_textController.text.isEmpty) return;
    
    setState(() {
      _isAnalyzing = true;
      _dominantEmotion = null;
      _emotionResults = {};
    });
    
    try {
      final result = await ApiService.analyzeText(_textController.text)
          .timeout(const Duration(seconds: 15));
      
      setState(() {
        _dominantEmotion = result['dominant_emotion'];
        _emotionResults = Map<String, dynamic>.from(result['emotions']);
      });
    } on TimeoutException {
      setState(() {
        _dominantEmotion = 'Tiempo de espera agotado';
      });
    } catch (e) {
      setState(() {
        _dominantEmotion = 'Error en el análisis';
      });
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'feliz': return Colors.green;
      case 'triste': return Colors.blue;
      case 'enojado': return Colors.red;
      case 'sorpresa': return Colors.amber;
      case 'miedo': return Colors.purple;
      case 'tranquilo': return Colors.lightBlue;
      case 'neutral': return Colors.grey;
      default: return Colors.orange;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF7043), Color(0xFFFFAB91)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '🔥 Analiza texto para detectar emociones',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBF360C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _textController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Escribe cómo te sientes hoy...',
                      labelText: 'Texto a analizar',
                      filled: true,
                      fillColor: const Color(0xFFFFE0B2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: (d) async {
                      _onTapUp(d);
                      await _analyzeText();
                    },
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD84315),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: _isAnalyzing
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Analizando...', style: TextStyle(color: Colors.white)),
                                ],
                              )
                            : const Text(
                                'Analizar texto',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_isAnalyzing)
                    const CircularProgressIndicator(color: Color(0xFFD84315))
                  else if (_textController.text.isNotEmpty && !_isAnalyzing)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultados del análisis:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBF360C),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_dominantEmotion != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              "Emoción dominante: ${_capitalize(_dominantEmotion!)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                          ),
                        if (_emotionResults.isNotEmpty)
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _emotionResults.entries.map((entry) {
                              return Chip(
                                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                backgroundColor: _getEmotionColor(entry.key).withOpacity(0.2),
                                label: Text(
                                  '${_capitalize(entry.key)}: ${entry.value}%',
                                  style: TextStyle(
                                    color: _getEmotionColor(entry.key).withOpacity(0.8),
                                  ),
                                ),
                                avatar: CircleAvatar(
                                  backgroundColor: _getEmotionColor(entry.key),
                                  child: Text(
                                    '${entry.value.toString().split('.')[0]}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
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