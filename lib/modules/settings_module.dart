import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode(bool value) {
    _isDarkModeEnabled = value;
    notifyListeners();
  }
}

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'Español';

  String get selectedLanguage => _selectedLanguage;

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}

class SettingsModule extends StatefulWidget {
  const SettingsModule({super.key});

  @override
  _SettingsModuleState createState() => _SettingsModuleState();
}

class _SettingsModuleState extends State<SettingsModule> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            final bool isDark = themeProvider.isDarkModeEnabled;
            final Color backgroundColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF3F0FA);
            final Color cardColor = isDark ? const Color(0xFF2E2E4D) : Colors.white;
            final Color titleColor = isDark ? Colors.white : const Color(0xFF2D1B5A);
            final Color accent = const Color(0xFF9D70FF);

            return Scaffold(
              backgroundColor: backgroundColor,
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    '⚡ Configuración',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor),
                  ),
                  const SizedBox(height: 30),
                  _buildSettingsSection('Preferencias', cardColor, [
                    _buildSettingsSwitch('Notificaciones', _notificationsEnabled, (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    }, accent),
                    _buildSettingsSwitch('Modo oscuro', themeProvider.isDarkModeEnabled, (value) {
                      themeProvider.toggleDarkMode(value);
                    }, accent),
                    _buildSettingsOption('Idioma', languageProvider.selectedLanguage, Icons.language, accent, () {
                      _showLanguageDialog(languageProvider);
                    }),
                  ]),
                  const SizedBox(height: 30),
                  _buildSettingsSection('Privacidad', cardColor, [
                    _buildSettingsOption('Política de privacidad', '', Icons.privacy_tip, const Color(0xFF72EDF2), _navigateToPrivacyPolicy),
                    _buildSettingsOption('Términos de servicio', '', Icons.description, const Color(0xFFFFD166), _navigateToTermsOfService),
                  ]),
                  const SizedBox(height: 30),
                  _buildSettingsSection('Cuenta', cardColor, [
                    _buildSettingsOption('Cerrar sesión', '', Icons.logout, Colors.redAccent, _logOut),
                    _buildSettingsOption('Eliminar cuenta', '', Icons.delete, Colors.red, _deleteAccount),
                  ]),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Versión 1.0.0',
                      style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Español'),
              value: 'Español',
              groupValue: languageProvider.selectedLanguage,
              onChanged: (value) {
                languageProvider.changeLanguage(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile(
              title: const Text('English'),
              value: 'English',
              groupValue: languageProvider.selectedLanguage,
              onChanged: (value) {
                languageProvider.changeLanguage(value!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a Política de privacidad')),
    );
  }

  void _navigateToTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a Términos de servicio')),
    );
  }

  void _logOut() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada')),
    );
    Navigator.of(context).pushNamed('/login');
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cuenta eliminada')),
    );
    Navigator.of(context).pushNamed('/login');
  }

  Widget _buildSettingsSection(String title, Color cardColor, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 15),
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(children: options),
        ),
      ],
    );
  }

  Widget _buildSettingsSwitch(String title, bool value, ValueChanged<bool> onChanged, Color accent) {
    return SwitchListTile(
      activeColor: accent,
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingsOption(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
