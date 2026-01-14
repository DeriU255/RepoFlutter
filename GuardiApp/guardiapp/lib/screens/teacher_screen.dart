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
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('${profe.nombre} ${profe.apellido}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (profe.imagenPerfil != null)
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profe.imagenPerfil!),
                              ),
                            const SizedBox(height: 16),
                            Text('Asignatura: ${profe.asignatura}', 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: Text(profe.email),
                            ),
                            if (profe.numeroTelefono != null)
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: Text(profe.numeroTelefono!),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
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
