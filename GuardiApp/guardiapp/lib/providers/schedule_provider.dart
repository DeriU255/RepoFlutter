import 'package:flutter/material.dart';
import 'package:guardiapp/models/schedule_model.dart';

class HorarioProvider extends ChangeNotifier {
  final List<ClaseHorario> _horario = [
    //Lunes
    ClaseHorario(id: '1', dia: 'Lunes', horaInicio: '08:00', horaFin: '08:55', asignatura: 'Matemáticas', grupo: '1º ESO A', aula: 'A-101'),
    ClaseHorario(id: '2', dia: 'Lunes', horaInicio: '08:55', horaFin: '09:50', asignatura: 'Lengua', grupo: '1º ESO A', aula: 'A-101'),
    ClaseHorario(id: '3', dia: 'Lunes', horaInicio: '09:50', horaFin: '10:45', asignatura: 'Inglés', grupo: '1º ESO A', aula: 'A-101'),
    ClaseHorario(id: '4', dia: 'Lunes', horaInicio: '11:15', horaFin: '12:10', asignatura: 'Biología', grupo: '1º ESO A', aula: 'Lab-1'),
    
    //Martes
    ClaseHorario(id: '11', dia: 'Martes', horaInicio: '08:00', horaFin: '08:55', asignatura: 'Historia', grupo: '2º BACH A', aula: 'B-201'),
    ClaseHorario(id: '12', dia: 'Martes', horaInicio: '08:55', horaFin: '09:50', asignatura: 'Filosofía', grupo: '2º BACH A', aula: 'B-201'),
    
    //Miércoles
    ClaseHorario(id: '21', dia: 'Miércoles', horaInicio: '10:45', horaFin: '11:15', asignatura: 'Guardia', grupo: 'Pasillo 1', aula: '-'),
    
    //Jueves
    ClaseHorario(id: '31', dia: 'Jueves', horaInicio: '12:10', horaFin: '13:05', asignatura: 'Tutoría', grupo: '1º ESO A', aula: 'A-101'),
    
    //Viernes
    ClaseHorario(id: '41', dia: 'Viernes', horaInicio: '13:05', horaFin: '14:00', asignatura: 'Educación Física', grupo: '1º ESO A', aula: 'Gimnasio'),
  ];

  List<ClaseHorario> get horario => _horario;
  
  List<ClaseHorario> obtenerHorarioDelDia(String dia) {
    //Filtramos ignorando mayúsculas/minúsculas y tildes si fuera necesario, 
    //pero aquí asumimos coincidencias exactas 'Lunes', 'Martes', etc.
    return _horario.where((c) => c.dia == dia).toList();
  }
}
