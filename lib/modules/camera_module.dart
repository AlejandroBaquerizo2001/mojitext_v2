import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mojitext_v2/services/api_service.dart';

class CameraModule extends StatefulWidget {
  const CameraModule({super.key});

  @override
  State<CameraModule> createState() => _CameraModuleState();
}

class _CameraModuleState extends State<CameraModule> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _captured = false;
  String _emotion = 'Esperando...';
  double _confidence = 0.0;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureEmotion() async {
    if (!_captured) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _captured = true;
          _emotion = 'Analizando...';
          _confidence = 0.0;
        });

        try {
          final response = await ApiService.analyzeImage(_imageFile!);
          
          if (response['status'] == 'success') {
            setState(() {
              _emotion = response['dominant_emotion'];
              _confidence = response['emotions'][_emotion] ?? 0.0;
            });
          } else {
            setState(() {
              _emotion = 'Error: ${response['detail'] ?? 'Desconocido'}';
            });
          }
        } catch (e) {
          setState(() {
            _emotion = 'Error en el análisis';
          });
          debugPrint('Error al analizar imagen: $e');
        }
      }
    } else {
      setState(() {
        _captured = false;
        _emotion = 'Esperando...';
        _imageFile = null;
        _confidence = 0.0;
      });
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'feliz': return Colors.green;
      case 'triste': return Colors.blue;
      case 'enojado': return Colors.red;
      case 'sorpresa': return Colors.amber;
      case 'miedo': return Colors.purple;
      case 'neutral': return Colors.grey;
      default: return const Color(0xFF3366CC);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFDDEEFF), Color(0xFFF4FAFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC4DBF6), Color(0xFFE2F0FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white70,
                            offset: Offset(-6, -6),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(6, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded, 
                                    size: 60, 
                                    color: Color(0xFF3366CC)),
                                SizedBox(height: 20),
                                Text(
                                  'Vista previa de la cámara',
                                  style: TextStyle(
                                    color: Color(0xFF3366CC),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 30),

                    // Botón animado
                    GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: (d) {
                        _onTapUp(d);
                        _captureEmotion();
                      },
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3366CC),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera, color: Colors.white),
                              const SizedBox(width: 12),
                              Text(
                                _captured ? 'Reintentar' : 'Capturar emoción',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'Emoción detectada:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C3D73),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      label: Text(
                        _emotion == 'Analizando...' 
                            ? _emotion
                            : '${_capitalize(_emotion)} (${_confidence.toStringAsFixed(1)}%)',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _emotion == 'Esperando...' || 
                                      _emotion == 'Analizando...'
                          ? Colors.grey
                          : _emotion.contains('Error')
                              ? Colors.red
                              : _getEmotionColor(_emotion),
                      elevation: 4,
                      shadowColor: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}