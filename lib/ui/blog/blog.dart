class Blog {
  String uuid;
  String title;
  String content;
  String author;
  String summary;
  String? imageUrl;
  List<String>? tags;
  DateTime publishedDate;

  Blog(
      {required this.uuid,
      required this.title,
      required this.content,
      required this.author,
      required this.publishedDate,
      required this.summary,
      this.imageUrl,
      this.tags});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'content': content,
      'author': author,
      'summary': summary,
      'imageUrl': imageUrl,
      'tags': tags,
      'publishedDate': publishedDate.toIso8601String()
    };
  }

  static Blog fromMap(Map<String, dynamic> map, String id) {
    return Blog(
        uuid: map['uuid'],
        title: map['title'],
        content: map['content'],
        author: map['author'],
        publishedDate: DateTime.parse(map['publishedDate']),
        summary: map['summary'],
        imageUrl: map['imageUrl'],
        tags: List<String>.from(map['tags'] ?? []));
  }
}
