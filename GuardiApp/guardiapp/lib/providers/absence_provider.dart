import 'package:flutter/material.dart';
import 'package:guardiapp/models/absence_model.dart';

class AusenciasProvider extends ChangeNotifier {
  // Lista inicial de datos simulados
  final List<Ausencia> _ausencias = [
    Ausencia(
      id: '1',
      nombreProfesor: 'Laura Martínez',
      asignatura: 'Matemáticas',
      grupo: '2º ESO A',
      fecha: DateTime.now(),
      hora: '08:00 - 08:55',
    ),
    Ausencia(
      id: '2',
      nombreProfesor: 'David Ruiz',
      asignatura: 'Historia',
      grupo: '1º BachILL',
      fecha: DateTime.now(),
      hora: '10:15 - 11:10',
      estado: EstadoAusencia.justificada,
    ),
  ];

  List<Ausencia> get ausencias => _ausencias;

  // Cambiar estado de la ausencia (No Justificada <-> Justificada)
  void alternarEstado(String id) {
    final indice = _ausencias.indexWhere((a) => a.id == id);
    if (indice != -1) {
      if (_ausencias[indice].estado == EstadoAusencia.noJustificada) {
        _ausencias[indice].estado = EstadoAusencia.justificada;
      } else {
        _ausencias[indice].estado = EstadoAusencia.noJustificada;
      }
      notifyListeners();
    }
  }

  void agregarAusencia(Ausencia ausencia) {
    _ausencias.add(ausencia);
    notifyListeners();
  }
}
