import 'package:flutter/material.dart';
import 'package:guardiapp/models/event_model.dart';

class CalendarioProvider extends ChangeNotifier {
  // Map para buscar eventos por fecha rápidamente
  final Map<DateTime, List<EventoCalendario>> _eventos = {};

  Map<DateTime, List<EventoCalendario>> get eventos => _eventos;

  CalendarioProvider() {
    _cargarEventosSimulados();
  }

  void _cargarEventosSimulados() {
    final hoy = DateTime.now();
    
    // Función auxiliar para normalizar fecha (sin hora)
    DateTime fechaSinHora(DateTime fecha) {
      return DateTime.utc(fecha.year, fecha.month, fecha.day);
    }

    // Eventos para hoy
    final keyHoy = fechaSinHora(hoy);
    _eventos[keyHoy] = [
      EventoCalendario(
        id: '1', 
        titulo: 'Entrega de Notas', 
        fecha: hoy, 
        tipo: TipoEvento.reunion,
        descripcion: 'Reunión de evaluación 2º Trimestre'
      ),
      EventoCalendario(
        id: '2', 
        titulo: 'Examen Matemáticas', 
        fecha: hoy, 
        tipo: TipoEvento.examen,
        descripcion: 'Tema 5 y 6'
      ),
    ];

    // Evento para mañana
    final manana = hoy.add(const Duration(days: 1));
    final keyManana = fechaSinHora(manana);
    _eventos[keyManana] = [
      EventoCalendario(
        id: '3', 
        titulo: 'Claustro de Profesores', 
        fecha: manana, 
        tipo: TipoEvento.reunion
      ),
    ];

    // Evento para dentro de 3 días
    final futuro = hoy.add(const Duration(days: 3));
    final keyFuturo = fechaSinHora(futuro);
    _eventos[keyFuturo] = [
      EventoCalendario(
        id: '4', 
        titulo: 'Día de la Constitución', 
        fecha: futuro, 
        tipo: TipoEvento.festivo
      ),
    ];
  }

  List<EventoCalendario> obtenerEventosDia(DateTime dia) {
    // Normalizamos la fecha para que coincida con las claves del Map (Time 00:00:00)
    final fechaNormalizada = DateTime.utc(dia.year, dia.month, dia.day);
    return _eventos[fechaNormalizada] ?? [];
  }

  void agregarEvento(EventoCalendario evento) {
    final fechaNormalizada = DateTime.utc(evento.fecha.year, evento.fecha.month, evento.fecha.day);
    
    if (_eventos.containsKey(fechaNormalizada)) {
      _eventos[fechaNormalizada]!.add(evento);
    } else {
      _eventos[fechaNormalizada] = [evento];
    }
    notifyListeners();
  }
}
