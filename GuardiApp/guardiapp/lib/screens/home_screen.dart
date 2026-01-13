import 'package:flutter/material.dart';
import 'package:guardiapp/screens/teacher_screen.dart';
import 'package:guardiapp/screens/absence_screen.dart';
import 'package:guardiapp/screens/schedule_screen.dart';
import 'package:guardiapp/screens/calendar_screen.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuardiApp Escolar'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _TarjetaMenu(
            titulo: 'Profesores',
            icono: Icons.people,
            color: Colors.teal,
            alPresionar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaProfesores()),
              );
            },
          ),
          _TarjetaMenu(
            titulo: 'Ausencias',
            icono: Icons.person_off,
            color: Colors.redAccent,
            alPresionar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaAusencias()),
              );
            },
          ),
          _TarjetaMenu(
            titulo: 'Horario',
            icono: Icons.schedule,
            color: Colors.blueAccent,
            alPresionar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaHorario()),
              );
            },
          ),
          _TarjetaMenu(
            titulo: 'Calendario',
            icono: Icons.calendar_month,
            color: Colors.orange,
            alPresionar: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaCalendario()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TarjetaMenu extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final VoidCallback alPresionar;

  const _TarjetaMenu({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: alPresionar,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icono, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
