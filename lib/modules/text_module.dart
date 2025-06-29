import 'package:flutter/material.dart';

class TextModule extends StatefulWidget {
  const TextModule({super.key});

  @override
  State<TextModule> createState() => _TextModuleState();
}

class _TextModuleState extends State<TextModule> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Fondo cálido
      body: Stack(
        children: [
          // Fondo tipo calor/lava
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
          // Contenido principal
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
                    onTapUp: (d) {
                      _onTapUp(d);
                      setState(() => _isAnalyzing = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _isAnalyzing = false);
                      });
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
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildEmotionChip('Feliz', 85, Colors.deepOrange),
                            _buildEmotionChip('Tristeza', 15, Colors.brown),
                            _buildEmotionChip('Enojo', 65, Colors.redAccent),
                            _buildEmotionChip('Sorpresa', 30, Colors.amber),
                            _buildEmotionChip('Miedo', 10, Colors.purple),
                          ],
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

  Widget _buildEmotionChip(String emotion, int percent, Color color) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      backgroundColor: color.withOpacity(0.2),
      label: Text('$emotion: $percent%'),
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          percent.toString(),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
