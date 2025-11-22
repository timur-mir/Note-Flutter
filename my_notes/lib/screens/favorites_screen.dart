import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final favoriteNotes = notesProvider.notes.where((note) => note.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: ListView.builder(
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = favoriteNotes[index];
          return ListTile(
            title:  SelectableText(
              note.title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: editableTextState.contextMenuButtonItems,
                );
              },

            ),
            subtitle:  SelectableText(
              note.content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: editableTextState.contextMenuButtonItems,
                );
              },

            ),
            trailing: IconButton(
              icon: Icon(
                note.isFavorite ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => notesProvider.toggleFavorite(note.id!),
            ),
          );
        },
      ),
      backgroundColor: Color.fromARGB(142, 129, 186, 100),
    );
  }
}