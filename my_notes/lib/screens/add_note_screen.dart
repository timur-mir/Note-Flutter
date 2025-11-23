import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Новая заметка')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Заголовок'),
                validator: (value) => value!.isEmpty ? 'Введите заголовок' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Текст заметки'),
                validator: (value) => value!.isEmpty ? 'Введите текст' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Создаём новую заметку
                    final newNote = Note(
                      title: _titleController.text,
                      content: _contentController.text,
                      date: DateTime.now(),
                      isFavorite: false,
                    );

                    // Добавляем в базу данных
                    notesProvider.addNote(newNote);
                    _showToast(context);
                    // Закрываем экран
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 232, 186, 186),
    );
  }
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Заметка сохранена'),
        backgroundColor:Color.fromARGB(255, 220, 170, 170),
        action: SnackBarAction(textColor:Color.fromARGB(255, 242, 247, 252),
            label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}