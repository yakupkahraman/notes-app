import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:binote/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  List<Note> _currentNotes = [];
  List<Note> get currentNotes => _currentNotes;

  set currentNotes(List<Note> notes) {
    _currentNotes = notes;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final newNote = Note()
      ..title = title
      ..content = content
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  Future<void> addNoteWithId(int id, String title, String content, DateTime updatedAt) async {
    final newNote = Note()
      ..id = id
      ..title = title
      ..content = content
      ..updatedAt = updatedAt;

    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await isar.notes.where().findAll();
    currentNotes = fetchedNotes;
  }

  Future<void> updateNote(int id, String newTitle, String newContent) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote
        ..title = newTitle
        ..content = newContent
        ..updatedAt = DateTime.now();

      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
