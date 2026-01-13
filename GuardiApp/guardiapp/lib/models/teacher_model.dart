class Profesor {
  final String nombre;
  final String apellido;
  final String email;
  final String? genero;
  final String? imagenPerfil;
  final String? numeroTelefono;

  Profesor({
    required this.nombre,
    required this.apellido,
    required this.email,
    this.genero,
    this.imagenPerfil,
    this.numeroTelefono,
  });

  factory Profesor.fromMap(Map<String, dynamic> map) {
    return Profesor(
      nombre: map['name']['first'] ?? 'Nombre',
      apellido: map['name']['last'] ?? 'Apellido',
      email: map['email'] ?? 'Correo',
      genero: map['gender'],
      imagenPerfil: map['picture'] != null ? map['picture']['medium'] : null,
      numeroTelefono: map['phone'],
    );
  }
}
