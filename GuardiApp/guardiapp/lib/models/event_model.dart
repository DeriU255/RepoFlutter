enum TipoEvento { examen, reunion, festivo, tarea }

class EventoCalendario {
  final String id;
  final String titulo;
  final DateTime fecha;
  final TipoEvento tipo;
  final String? descripcion;

  EventoCalendario({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.tipo,
    this.descripcion,
  });
}
