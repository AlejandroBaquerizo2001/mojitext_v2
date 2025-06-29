import 'package:flutter/material.dart';

class VoiceModule extends StatefulWidget {
  const VoiceModule({super.key});

  @override
  State<VoiceModule> createState() => _VoiceModuleState();
}

class _VoiceModuleState extends State<VoiceModule> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _recording = false;

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

  void _toggleRecording() {
    setState(() => _recording = !_recording);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1EB),
      body: Stack(
        children: [
          // Fondo decorativo tipo hojas suaves
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
          // Contenido principal
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

                  // Botón con animación
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
                    child: const LinearProgressIndicator(
                      value: 0.7,
                      minHeight: 10,
                      color: Color(0xFF4E944F),
                      backgroundColor: Color(0xFFDFF0D8),
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
                  const Chip(
                    label: Text('Neutral', style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xFF90A955),
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
