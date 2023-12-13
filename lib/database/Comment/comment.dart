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
      'uuid': uuid,
      'content': content,
      'author': author,
      'date': date,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String id) {
    return Comment(
        uuid: map['uuid'],
        content: map['content'],
        author: map['author'],
        date: map['date']
    );
  }
}
