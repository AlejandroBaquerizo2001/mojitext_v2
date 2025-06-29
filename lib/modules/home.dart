import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mojitext_v2/modules/camera_module.dart';
import 'package:mojitext_v2/modules/text_module.dart';
import 'package:mojitext_v2/modules/voice_module.dart';
import 'package:mojitext_v2/modules/settings_module.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ModuleGridScreen(),
    const EmotionStatsScreen(),
    const SettingsModule(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8D8EB), // azul cielo
        elevation: 0,
        title: const Text(
          'Emotion AI Detector',
          style: TextStyle(color: Color(0xFF1E4B75), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E4B75)),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF2E86AB),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFEAF4FB),
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
    );
  }
}

class ModuleGridScreen extends StatelessWidget {
  const ModuleGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildNeumorphicCard(
          context,
          'Detección por Cámara',
          Icons.camera_alt,
          const Color(0xFF6EC1E4), // celeste
          const CameraModule(),
        ),
        _buildNeumorphicCard(
          context,
          'Detección por Voz',
          Icons.mic,
          const Color(0xFF91D0C2), // verde claro azulado
          const VoiceModule(),
        ),
        _buildNeumorphicCard(
          context,
          'Análisis de Texto',
          Icons.text_fields,
          const Color(0xFFF3B562), // dorado pastel
          const TextModule(),
        ),
      ],
    );
  }

  Widget _buildNeumorphicCard(BuildContext context, String title, IconData icon, Color color, Widget moduleScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => moduleScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5FAFF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0xFFD6E4F0), offset: Offset(6, 6), blurRadius: 12),
            BoxShadow(color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              radius: 28,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E86AB)),
            ),
            const SizedBox(height: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class EmotionStatsScreen extends StatelessWidget {
  const EmotionStatsScreen({super.key});

  final List<Map<String, dynamic>> emotionHistory = const [
    {'emotion': 'Feliz', 'icon': Icons.sentiment_satisfied, 'date': '27 Jun - 09:46'},
    {'emotion': 'Triste', 'icon': Icons.sentiment_dissatisfied, 'date': '27 Jun - 09:40'},
    {'emotion': 'Enojado', 'icon': Icons.sentiment_very_dissatisfied, 'date': '26 Jun - 17:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '📊 Estadísticas Emocionales',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E4B75)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 40, title: 'Feliz', color: Colors.green, radius: 50),
                  PieChartSectionData(value: 30, title: 'Triste', color: Colors.blue, radius: 50),
                  PieChartSectionData(value: 30, title: 'Enojado', color: Colors.redAccent, radius: 50),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '🌬️ Consejo del día:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E86AB)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FAFF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                BoxShadow(color: Colors.black12, offset: Offset(4, 4), blurRadius: 8),
              ],
            ),
            child: const Text(
              'La libertad está en el aire. Tómate un respiro, escucha el viento y sigue adelante 💨',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF2E86AB)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('🕓 Historial de emociones', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E4B75))),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: emotionHistory.length,
              itemBuilder: (context, index) {
                final item = emotionHistory[index];
                return ListTile(
                  leading: Icon(item['icon'], color: const Color(0xFF2E86AB)),
                  title: Text(item['emotion']),
                  subtitle: Text(item['date']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
