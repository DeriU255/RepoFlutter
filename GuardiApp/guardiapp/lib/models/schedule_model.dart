class ClaseHorario {
  final String id;
  final String dia; // 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'
  final String horaInicio;
  final String horaFin;
  final String asignatura;
  final String grupo;
  final String aula;

  ClaseHorario({
    required this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.asignatura,
    required this.grupo,
    required this.aula,
  });
}
