class Note {
  int? id;
  String title;
  String content;
  DateTime date;
  bool isFavorite; // Добавляем новое поле

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.isFavorite = false, // По умолчанию false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0, // SQLite не поддерживает bool, используем 0/1
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      isFavorite: map['isFavorite'] == 1, // Конвертируем обратно в bool
    );
  }
}