import 'package:flutter/material.dart';
import '../models/note.dart';
import '../database/database_helper.dart';


class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await DatabaseHelper.instance.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.insertNote(note);
    await loadNotes();
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.updateNote(note);
    await loadNotes();
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    await loadNotes();
    notifyListeners();
  }
  Future<void> toggleFavorite(int id) async {
    final db = await DatabaseHelper.instance.database;
    final note = _notes.firstWhere((note) => note.id == id);
    note.isFavorite = !note.isFavorite;
    await db.update(
      'notes',
      {'isFavorite': note.isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }
}