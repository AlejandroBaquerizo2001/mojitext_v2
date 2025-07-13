import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = "http://192.168.100.51:8000";

  static Future<Map<String, dynamic>> analyzeText(String text) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/analyze_text"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'text': text},
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Error desconocido');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error al analizar texto: $e');
    }
  }

  static Future<Map<String, dynamic>> analyzeVoice(File audioFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/analyze_voice"),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        audioFile.path,
        contentType: MediaType('audio', 'aac'),
      ));

      final response = await request.send().timeout(const Duration(seconds: 20));
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Error desconocido');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error al analizar voz: $e');
    }
  }

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/analyze_image"),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      final response = await request.send().timeout(const Duration(seconds: 20));
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Error desconocido');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error al analizar imagen: $e');
    }
  }
}