import 'package:blog_test/model/comment.dart';

class BlogPost {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final DateTime? lastEditedAt;
  final List<Comment> comments;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.lastEditedAt,
    required this.comments,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      createdAt: DateTime.parse(json['createdAt']),
      lastEditedAt: json['lastEditedAt'] != null
          ? DateTime.parse(json['lastEditedAt'])
          : null,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((commentJson) => Comment.fromJson(commentJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'lastEditedAt': lastEditedAt?.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPost &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          author == other.author &&
          createdAt == other.createdAt &&
          lastEditedAt == other.lastEditedAt &&
          comments == other.comments;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ content.hashCode;
}
