import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:guardiapp/models/absence_model.dart';
import 'package:guardiapp/models/teacher_model.dart';
import 'package:guardiapp/providers/absence_provider.dart';
import 'package:guardiapp/providers/teacher_provider.dart';

class PantallaCrearAusencia extends StatefulWidget {
  const PantallaCrearAusencia({super.key});

  @override
  State<PantallaCrearAusencia> createState() => _PantallaCrearAusenciaState();
}

class _PantallaCrearAusenciaState extends State<PantallaCrearAusencia> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores y variables de estado
  final _asignaturaController = TextEditingController();
  final _grupoController = TextEditingController();
  final _horaController = TextEditingController();
  final _detallesController = TextEditingController();
  
  Profesor? _profesorSeleccionado;
  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    _asignaturaController.dispose();
    _grupoController.dispose();
    _horaController.dispose();
    _detallesController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );
    if (picked != null) {
      setState(() {
        _horaSeleccionada = picked;
        // Actualizamos el texto para visualización rápida
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _horaController.text = '$hour:$minute';
      });
    }
  }

  void _guardarAusencia() {
    if (_formKey.currentState!.validate()) {
      if (_profesorSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un profesor')),
        );
        return;
      }

      // Creamos la nueva ausencia
      final nuevaAusencia = Ausencia(
        id: DateTime.now().toString(), // ID temporal basado en timestamp
        nombreProfesor: '${_profesorSeleccionado!.nombre} ${_profesorSeleccionado!.apellido}',
        asignatura: _asignaturaController.text,
        grupo: _grupoController.text,
        fecha: _fechaSeleccionada,
        hora: _horaController.text.isEmpty 
            ? '${_horaSeleccionada.hour.toString().padLeft(2,'0')}:${_horaSeleccionada.minute.toString().padLeft(2,'0')}' 
            : _horaController.text,
        detalles: _detallesController.text,
        estado: EstadoAusencia.noJustificada,
      );

      // Usamos el provider para añadirla
      Provider.of<AusenciasProvider>(context, listen: false).agregarAusencia(nuevaAusencia);

      // Volvemos atrás
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ausencia registrada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de profesores para el dropdown
    final listaProfesores = Provider.of<ProfesoresProvider>(context).profesores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Ausencia'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Profesor
              DropdownButtonFormField<Profesor>(
                decoration: const InputDecoration(
                  labelText: 'Profesor',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                value: _profesorSeleccionado,
                items: listaProfesores.map((Profesor profe) {
                  return DropdownMenuItem<Profesor>(
                    value: profe,
                    child: Text('${profe.nombre} ${profe.apellido}'),
                  );
                }).toList(),
                onChanged: (Profesor? value) {
                  setState(() {
                    _profesorSeleccionado = value;
                  });
                },
                validator: (value) => value == null ? 'Selecciona un profesor' : null,
              ),
              const SizedBox(height: 16),

              // Asignatura
              TextFormField(
                controller: _asignaturaController,
                decoration: const InputDecoration(
                  labelText: 'Asignatura',
                  icon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce la asignatura';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grupo
              TextFormField(
                controller: _grupoController,
                decoration: const InputDecoration(
                  labelText: 'Grupo',
                  icon: Icon(Icons.group),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce el grupo (ej. 2DAM)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fila para Fecha y Hora
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarFecha(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          icon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_fechaSeleccionada),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _seleccionarHora(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora',
                          icon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _horaController.text.isEmpty 
                            ? '${_horaSeleccionada.hour.toString().padLeft(2,'0')}:${_horaSeleccionada.minute.toString().padLeft(2,'0')}'
                            : _horaController.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Detalles opcionales
              TextFormField(
                controller: _detallesController,
                decoration: const InputDecoration(
                  labelText: 'Detalles (Opcional)',
                  icon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardarAusencia,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Ausencia'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
