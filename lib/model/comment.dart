class Comment {
  final int id;
  final int blogId;
  final int commentNumber;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime? lastEditedAt;

  Comment({
    required this.id,
    required this.blogId,
    required this.commentNumber,
    required this.content,
    required this.author,
    required this.createdAt,
    this.lastEditedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      blogId: json['blogId'],
      commentNumber: json['commentNumber'],
      content: json['content'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      lastEditedAt: json['lastEditedAt'] != null
          ? DateTime.parse(json['lastEditedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blogId': blogId,
      'commentNumber': commentNumber,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'lastEditedAt': lastEditedAt?.toIso8601String(),
    };
  }
}
