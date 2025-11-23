import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои заметки')),
      body: FutureBuilder(
        future: notesProvider.loadNotes(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (snapshot.hasError) {
            return Center(child: Text("Ошибка:${snapshot.error}"));
          }
          final notes = Provider.of<NotesProvider>(context).notes;
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              // final note = notesProvider.notes[index];
              final note = notes[index];
              return ListTile(
                title: Text(note.title,maxLines: 2,style: TextStyle(color: Colors.red,fontSize: 18)),
                subtitle: SelectableText(
                  note.content,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                  ),
                  contextMenuBuilder: (context, editableTextState) {
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: editableTextState.contextMenuButtonItems,
                    );
                  },
                  // toolbarOptions: ToolbarOptions(
                  //   copy: true, // Включить возможность копирования
                  //   selectAll: true, // Включить выделение всего текста
                  // ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        note.isFavorite ? Icons.star : Icons.star_border,
                        color: note.isFavorite ? Colors.amber : null,
                      ),
                      onPressed: () => notesProvider.toggleFavorite(note.id!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => notesProvider.deleteNote(note.id!),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Color.fromARGB(255, 181, 231, 238),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNoteScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
