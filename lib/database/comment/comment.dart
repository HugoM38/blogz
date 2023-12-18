class Comment {
  String content;
  String author;
  String uuid;
  DateTime date;

  Comment({
    required this.content,
    required this.author,
    required this.uuid,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
      'uuid': uuid,
      'date': date.toString(),
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String id) {
    return Comment(
        content: map['content'],
        author: map['author'],
        uuid: map['uuid'],
        date: DateTime.parse(map['date']));
  }
}
