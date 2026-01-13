import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardiapp/providers/absence_provider.dart';
import 'package:guardiapp/models/absence_model.dart';
import 'package:guardiapp/screens/create_absence_screen.dart';

class PantallaAusencias extends StatelessWidget {
  const PantallaAusencias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Ausencias'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AusenciasProvider>(
        builder: (context, provider, child) {
          final lista = provider.ausencias;

          if (lista.isEmpty) {
            return const Center(child: Text('No hay ausencias registradas.'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final ausencia = lista[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: CircleAvatar(
                    backgroundColor: _getColorEstado(ausencia.estado),
                    foregroundColor: Colors.white,
                    child: Icon(_getIconoEstado(ausencia.estado)),
                    
                  ),
                  title: Text(ausencia.asignatura),
                  subtitle: Text(
                    '${ausencia.nombreProfesor}\n${ausencia.grupo} - ${ausencia.hora}',
                  ),
                  isThreeLine: true,
                  trailing: Checkbox(
                    value: ausencia.estado == EstadoAusencia.justificada,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      provider.alternarEstado(ausencia.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PantallaCrearAusencia(),
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getColorEstado(EstadoAusencia estado) {
    switch (estado) {
      case EstadoAusencia.noJustificada: 
        return Colors.orange; // Naranja para advertir
      case EstadoAusencia.justificada: 
        return Colors.green; // Verde para OK
    }
  }

  IconData _getIconoEstado(EstadoAusencia estado) {
    switch (estado) {
      case EstadoAusencia.noJustificada:
        return Icons.warning_amber_rounded;
      case EstadoAusencia.justificada:
        return Icons.check;
    }
  }
}
