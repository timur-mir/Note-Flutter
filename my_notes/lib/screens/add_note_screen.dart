import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  final SpeechToText speechToText = SpeechToText();
  bool isListening = false;
  bool isListening2 = false;
  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (!available) {
      _showToast2(context);
    }
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
                validator: (value) =>
                    value!.isEmpty ? 'Введите заголовок' : null,
                onTap: () async {
                  if (!isListening) {
                    await speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          _titleController.text = result.recognizedWords;
                        });
                      },
                    );
                    setState(() => isListening = true);
                  } else {
                    speechToText.stop();
                    setState(() => isListening = false);
                  }

                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Текст заметки'),
                validator: (value) => value!.isEmpty ? 'Введите текст' : null,
                maxLines: 5,
                onTap: () async {
                  if (!isListening2) {
                    await speechToText.listen(
                      onResult: (result) {
                        setState(() {
                         _contentController.text = result.recognizedWords;
                        });
                      },
                    );
                    setState(() => isListening2 = true);
                  } else {
                    speechToText.stop();
                    setState(() => isListening2 = false);
                  }

                },
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
        backgroundColor: Color.fromARGB(255, 220, 170, 170),
        action: SnackBarAction(
          textColor: Color.fromARGB(255, 242, 247, 252),
          label: '',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  void _showToast2(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Ошибка при инициализации микрофона'),
        backgroundColor: Color.fromARGB(255, 192, 7, 7),
        action: SnackBarAction(
          textColor: Color.fromARGB(255, 242, 247, 252),
          label: '',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}
