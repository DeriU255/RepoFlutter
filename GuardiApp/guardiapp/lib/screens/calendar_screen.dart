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
  //Forzamos el formato a SEMANA para estilo planning
  final CalendarFormat _formatoCalendario = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Escolar'), // Nombre más técnico
        backgroundColor: Colors.indigo, // Color corporativo/serio
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
                //Eliminamos onFormatChanged para bloquear la vista
                selectedDayPredicate: (day) {
                  return isSameDay(_diaSeleccionado, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _diaSeleccionado = selectedDay;
                    _diaEnFoco = focusedDay;
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
                  //CAMBIO: Estilos azules (Indigo) en lugar de naranja
                  markerDecoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.indigo),
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
                    return _EventoCard(evento: evento);
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
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoAgregarEvento(BuildContext context) {
    final controladorTitulo = TextEditingController();
    TimeOfDay horaSeleccionada = TimeOfDay.now();
    TipoEvento tipoSeleccionado = TipoEvento.tarea;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Nuevo Evento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controladorTitulo,
                  decoration: const InputDecoration(
                    labelText: 'Título del evento',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoEvento>(
                  value: tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  items: TipoEvento.values.map((TipoEvento tipo) {
                    return DropdownMenuItem<TipoEvento>(
                      value: tipo,
                      child: Text(tipo.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (TipoEvento? newValue) {
                    if (newValue != null) {
                      setState(() {
                        tipoSeleccionado = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text('Hora: ${horaSeleccionada.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: horaSeleccionada,
                    );
                    if (picked != null) {
                      setState(() {
                        horaSeleccionada = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (controladorTitulo.text.isNotEmpty) {
                    // Combinamos la fecha seleccionada con la hora elegida
                    final fechaEvento = DateTime(
                      _diaSeleccionado.year,
                      _diaSeleccionado.month,
                      _diaSeleccionado.day,
                      horaSeleccionada.hour,
                      horaSeleccionada.minute,
                    );

                    final nuevoEvento = EventoCalendario(
                      id: DateTime.now().toString(),
                      titulo: controladorTitulo.text,
                      fecha: fechaEvento,
                      tipo: tipoSeleccionado,
                    );
                    Provider.of<CalendarioProvider>(context, listen: false).agregarEvento(nuevoEvento);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final EventoCalendario evento;

  const _EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    final colors = _getColoresEvento(evento.tipo);
    final primaryColor = colors['primary']!;
    final secondaryColor = colors['secondary']!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          onTap: () {
            // Aquí podríamos abrir detalles
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hora
                Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(evento.fecha),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('a').format(evento.fecha),
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (evento.descripcion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          evento.descripcion!,
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Chip sencillo para el tipo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          evento.tipo.toString().split('.').last.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
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
  }

  Map<String, Color> _getColoresEvento(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.examen:
        return {'primary': Colors.red, 'secondary': Colors.red.shade50};
      case TipoEvento.reunion:
        return {'primary': Colors.blue, 'secondary': Colors.blue.shade50};
      case TipoEvento.festivo:
        return {'primary': Colors.green, 'secondary': Colors.green.shade50};
      case TipoEvento.tarea:
        return {'primary': Colors.orange, 'secondary': Colors.orange.shade50};
    }
  }
}

