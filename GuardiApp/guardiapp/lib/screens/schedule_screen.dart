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
          title: const Text('Horario Escolar'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            tabs: dias.map((dia) => Tab(text: dia.substring(0, 3))).toList(),
          ),
        ),
        backgroundColor: Colors.grey[50],
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.weekend, size: 64, color: Colors.indigo.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'No hay clases programadas',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: clases.length,
      itemBuilder: (context, index) {
        final clase = clases[index];
        final colors = _generarColorAsignatura(clase.asignatura);
        final primaryColor = colors['primary']!;
        final secondaryColor = colors['secondary']!;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: primaryColor, width: 6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {}, // Futuro: Ver detalles de la clase
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Columna de Hora (Izquierda)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clase.horaInicio,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          clase.horaFin,
                          style: TextStyle(
                            fontSize: 13,
                            color: primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(height: 40, width: 1, color: primaryColor.withValues(alpha: 0.2)),
                    const SizedBox(width: 16),
                    
                    // Contenido (Centro)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clase.asignatura,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.group, size: 14, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                clase.grupo,
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.room, size: 14, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                clase.aula,
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Generador de colores consistentes basado en el nombre de la asignatura
  Map<String, Color> _generarColorAsignatura(String asignatura) {
    if (asignatura.toLowerCase().contains('matem')) {
      return {'primary': Colors.red, 'secondary': Colors.red.shade50};
    } else if (asignatura.toLowerCase().contains('lengua')) {
      return {'primary': Colors.blue, 'secondary': Colors.blue.shade50};
    } else if (asignatura.toLowerCase().contains('inglés') || asignatura.toLowerCase().contains('ingles')) {
      return {'primary': Colors.indigo, 'secondary': Colors.indigo.shade50};
    } else if (asignatura.toLowerCase().contains('historia') || asignatura.toLowerCase().contains('filosofía')) {
      return {'primary': Colors.amber.shade800, 'secondary': Colors.amber.shade50};
    } else if (asignatura.toLowerCase().contains('biología') || asignatura.toLowerCase().contains('física')) {
      return {'primary': Colors.green, 'secondary': Colors.green.shade50};
    } else if (asignatura.toLowerCase().contains('guardia')) {
      return {'primary': Colors.purple, 'secondary': Colors.purple.shade50};
    }
    
    // Default
    return {'primary': Colors.blueGrey, 'secondary': Colors.blueGrey.shade50};
  }
}
