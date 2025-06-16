class Note {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;
  final String? imagePath;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
    this.imagePath,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
      'imagePath': imagePath
    };
  }

  factory Note.fromMap(Map<String, dynamic> map){
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime'],
      imagePath: map['imagePath'],
    );
  }
}