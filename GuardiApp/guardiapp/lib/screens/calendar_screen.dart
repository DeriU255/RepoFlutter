import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:guardiapp/providers/calendar_provider.dart';
import 'package:guardiapp/models/event_model.dart';
import 'package:intl/intl.dart';

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  DateTime _diaSeleccionado = DateTime.now();
  DateTime _diaEnFoco = DateTime.now();
  CalendarFormat _formatoCalendario = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario Escolar'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Widget de Calendario
          Consumer<CalendarioProvider>(
            builder: (context, provider, child) {
              return TableCalendar<EventoCalendario>(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _diaEnFoco,
                calendarFormat: _formatoCalendario,
                selectedDayPredicate: (day) {
                  return isSameDay(_diaSeleccionado, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _diaSeleccionado = selectedDay;
                    _diaEnFoco = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _formatoCalendario = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _diaEnFoco = focusedDay;
                },
                eventLoader: (day) {
                  return provider.obtenerEventosDia(day);
                },
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              );
            },
          ),
          
          const SizedBox(height: 8.0),
          const Divider(),
          
          // Lista de eventos del día seleccionado
          Expanded(
            child: Consumer<CalendarioProvider>(
              builder: (context, provider, child) {
                final eventos = provider.obtenerEventosDia(_diaSeleccionado);
                
                if (eventos.isEmpty) {
                  return const Center(
                    child: Text('No hay eventos para este día'),
                  );
                }

                return ListView.builder(
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final evento = eventos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: _getIconoTipo(evento.tipo),
                        title: Text(evento.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: evento.descripcion != null 
                            ? Text(evento.descripcion!) 
                            : null,
                        trailing: Text(
                          DateFormat.Hm().format(evento.fecha), 
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAgregarEvento(context);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Icon _getIconoTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.examen:
        return const Icon(Icons.assignment, color: Colors.red);
      case TipoEvento.reunion:
        return const Icon(Icons.groups, color: Colors.blue);
      case TipoEvento.festivo:
        return const Icon(Icons.celebration, color: Colors.green);
      case TipoEvento.tarea:
        return const Icon(Icons.task, color: Colors.orange);
    }
  }

  void _mostrarDialogoAgregarEvento(BuildContext context) {
    // Implementación básica para añadir evento rápido
    final controladorTitulo = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Evento'),
        content: TextField(
          controller: controladorTitulo,
          decoration: const InputDecoration(hintText: 'Título del evento'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controladorTitulo.text.isNotEmpty) {
                final nuevoEvento = EventoCalendario(
                  id: DateTime.now().toString(),
                  titulo: controladorTitulo.text,
                  fecha: _diaSeleccionado, // Usa el día seleccionado en el calendario
                  tipo: TipoEvento.tarea,
                );
                Provider.of<CalendarioProvider>(context, listen: false).agregarEvento(nuevoEvento);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
