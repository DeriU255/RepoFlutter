import 'dart:math';

class Profesor {
  final String nombre;
  final String apellido;
  final String email;
  final String? genero;
  final String? imagenPerfil;
  final String? numeroTelefono;
  final String asignatura;

  static const List<String> asignaturasPosibles = [
    'Matemáticas',
    'Lengua y Literatura',
    'Inglés',
    'Física y Química',
    'Biología y Geología',
    'Geografía e Historia',
    'Educación Física',
    'Música',
    'Tecnología',
    'Informática',
    'Filosofía',
    'Dibujo Técnico',
    'Economía',
    'Latín y Griego',
    'Francés'
  ];

  Profesor({
    required this.nombre,
    required this.apellido,
    required this.email,
    this.genero,
    this.imagenPerfil,
    this.numeroTelefono,
    required this.asignatura,
  });

  factory Profesor.fromMap(Map<String, dynamic> map) {
    return Profesor(
      nombre: map['name']['first'] ?? 'Nombre',
      apellido: map['name']['last'] ?? 'Apellido',
      email: map['email'] ?? 'Correo',
      genero: map['gender'],
      imagenPerfil: map['picture'] != null ? map['picture']['large'] : null, // Prefiero 'large' para el detalle si existe, o medium por defecto si venia asi. En randomuser suele venir large, medium, thumbnail. 'picture' suele tener los 3.
      numeroTelefono: map['phone'],
      asignatura: asignaturasPosibles[Random().nextInt(asignaturasPosibles.length)],
    );
  }
}

