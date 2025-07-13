import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VoiceModule extends StatefulWidget {
  const VoiceModule({super.key});

  @override
  State<VoiceModule> createState() => _VoiceModuleState();
}

class _VoiceModuleState extends State<VoiceModule> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _recording = false;
  String _emotion = 'No detectada';
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  String? _audioPath;

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
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    setState(() {
      _isRecorderReady = true;
    });
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  Future<String> analyzeVoice(File audioFile) async {
    try {
      // Leer el archivo como bytes
      final audioBytes = await audioFile.readAsBytes();
      
      // Simulación basada en tamaño del archivo (como en tu ejemplo Python)
      if (audioBytes.length < 10000) {
        return "Tranquilo";
      } else if (audioBytes.length < 50000) {
        return "Estresado";
      } else {
        return "Enojado";
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isRecorderReady) {
      await _initRecorder();
      return;
    }

    try {
      if (_recording) {
        await _recorder.stopRecorder();
        
        if (_audioPath != null) {
          final emotion = await analyzeVoice(File(_audioPath!));
          setState(() {
            _recording = false;
            _emotion = emotion;
          });
        }
      } else {
        final tempDir = await getTemporaryDirectory();
        _audioPath = '${tempDir.path}/audio_temp.aac';
        await _recorder.startRecorder(
          toFile: _audioPath!,
          codec: Codec.aacADTS,
        );
        
        setState(() {
          _recording = true;
          _emotion = 'Analizando...';
        });
      }
    } catch (e) {
      setState(() {
        _recording = false;
        _emotion = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1EB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB5D6A7), Color(0xFFE6F1EB)],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.forest, size: 80, color: Color(0xFF5A8F68)),
                  const SizedBox(height: 24),
                  const Text(
                    'Presiona el botón y habla para detectar emociones en tu voz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF3B5738),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),

                  GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: (d) {
                      _onTapUp(d);
                      _toggleRecording();
                    },
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          color: _recording ? const Color(0xFF90A955) : const Color(0xFF6BA368),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_recording ? Icons.stop : Icons.mic_none, color: Colors.white),
                            const SizedBox(width: 12),
                            Text(
                              _recording ? 'Detener' : 'Iniciar grabación',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: LinearProgressIndicator(
                      value: _recording ? null : 0.7,
                      minHeight: 10,
                      color: const Color(0xFF4E944F),
                      backgroundColor: const Color(0xFFDFF0D8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _recording ? 'Grabando...' : 'Procesando...',
                    style: const TextStyle(
                      color: Color(0xFF7B8B69),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Emoción detectada:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B5738),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(_emotion, style: const TextStyle(color: Colors.white)),
                    backgroundColor: const Color(0xFF90A955),
                    elevation: 4,
                    shadowColor: Colors.black26,
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