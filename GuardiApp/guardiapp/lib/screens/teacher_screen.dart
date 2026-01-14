import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardiapp/providers/teacher_provider.dart';

class PantallaProfesores extends StatelessWidget {
  const PantallaProfesores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claustro de Profesores'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfesoresProvider>(
        builder: (context, provider, child) {
          if (provider.cargando && provider.profesores.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: provider.profesores.length,
            itemBuilder: (context, index) {
              final profe = provider.profesores[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: profe.imagenPerfil != null 
                    ? NetworkImage(profe.imagenPerfil!) 
                    : null,
                  child: profe.imagenPerfil == null ? const Icon(Icons.person) : null,
                ),
                title: Text('${profe.nombre} ${profe.apellido}'),
                subtitle: Text(profe.email),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    // Detalle del profesor
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
