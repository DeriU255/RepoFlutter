import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardiapp/providers/schedule_provider.dart';
import 'package:guardiapp/models/schedule_model.dart';

class PantallaHorario extends StatelessWidget {
  const PantallaHorario({super.key});

  @override
  Widget build(BuildContext context) {
    final dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];

    return DefaultTabController(
      length: dias.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Horario'),
          backgroundColor: Colors.indigo, // Usar un color distinto para horarios
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: dias.map((dia) => Tab(text: dia.substring(0, 3))).toList(),
          ),
        ),
        body: Consumer<HorarioProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: dias.map((dia) {
                final clasesDelDia = provider.obtenerHorarioDelDia(dia);
                return _ListaClases(clases: clasesDelDia);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _ListaClases extends StatelessWidget {
  final List<ClaseHorario> clases;

  const _ListaClases({required this.clases});

  @override
  Widget build(BuildContext context) {
    if (clases.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay clases programadas para este día',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clases.length,
      itemBuilder: (context, index) {
        final clase = clases[index];
        return Card(
          elevation: 2,
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(clase.horaInicio, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                Text(clase.horaFin, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            title: Text(clase.asignatura, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${clase.grupo} • ${clase.aula}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}
