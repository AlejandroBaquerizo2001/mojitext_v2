import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(color: Color(0xFF5E3D2C)),
        ),
        backgroundColor: const Color(0xFFF4C542),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E3D2C)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Ícono decorativo estilo Liyue
            const Icon(Icons.pattern, size: 80, color: Color(0xFFF4C542)),
            const SizedBox(height: 16),
            const Text(
              'Ingresa tu correo electrónico y te enviaremos un enlace de recuperación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5E3D2C),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Color(0xFF5E3D2C)),
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                labelStyle: const TextStyle(color: Color(0xFF5E3D2C)),
                prefixIcon: const Icon(Icons.email, color: Color(0xFFD98032)),
                filled: true,
                fillColor: const Color(0xFFFFF8EC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD98032)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD98032), width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Enviar enlace',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty && email.contains('@')) {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        backgroundColor: Color(0xFFFFF8EC),
                        title: Text('📨 Correo enviado'),
                        content: Text('Te hemos enviado un enlace de recuperación.'),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context); // Cierra el diálogo
                      Navigator.pop(context); // Vuelve al login
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, introduce un correo válido')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD98032),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
