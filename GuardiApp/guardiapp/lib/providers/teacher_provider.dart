import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:guardiapp/models/teacher_model.dart';

class ProfesoresProvider extends ChangeNotifier {
  List<Profesor> _profesores = [];
  bool _cargando = false;

  List<Profesor> get profesores => _profesores;
  bool get cargando => _cargando;

  ProfesoresProvider() {
    cargarProfesores();
  }

  Future<void> cargarProfesores() async {
    if (_cargando) return;
    
    _cargando = true;
    notifyListeners();

    try {
      // Usamos randomuser.me simulando datos de profesores
      const url = 'https://randomuser.me/api/?results=15&nat=es';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        
        final nuevosProfesores = (json['results'] as List).map((e) {
          return Profesor.fromMap(e as Map<String, dynamic>);
        }).toList();

        _profesores.addAll(nuevosProfesores);
      } else {
        debugPrint('Error al cargar profesores: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
