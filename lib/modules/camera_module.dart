import 'package:flutter/material.dart';

class CameraModule extends StatefulWidget {
  const CameraModule({super.key});

  @override
  State<CameraModule> createState() => _CameraModuleState();
}

class _CameraModuleState extends State<CameraModule> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _captured = false;

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

  void _captureEmotion() {
    setState(() => _captured = !_captured);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF), // Fondo claro Fontaine
      body: Stack(
        children: [
          // Fondo con decoración tipo agua/niebla
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
          // Contenido principal
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, size: 60, color: Color(0xFF3366CC)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                                style: const TextStyle(color: Colors.white, fontSize: 16),
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
                        _captured ? 'Feliz' : 'Esperando...',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _captured ? const Color(0xFF00B8D9) : Colors.grey,
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
