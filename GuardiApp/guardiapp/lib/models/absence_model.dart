enum EstadoAusencia { noJustificada, justificada }

class Ausencia {
  final String id;
  final String nombreProfesor;
  final String asignatura;
  final String grupo;
  final DateTime fecha;
  final String hora; // Ej: "08:00 - 09:00"
  final String? detalles;
  EstadoAusencia estado;

  Ausencia({
    required this.id,
    required this.nombreProfesor,
    required this.asignatura,
    required this.grupo,
    required this.fecha,
    required this.hora,
    this.detalles,
    this.estado = EstadoAusencia.noJustificada,
  });
}
