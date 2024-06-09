class BlogPostDto {
  String title;
  String content;

  BlogPostDto({
    required this.title,
    required this.content,
  });

  factory BlogPostDto.fromJson(Map<String, dynamic> json) {
    return BlogPostDto(
      title: json['title'],
      content: json['content'],
    );
  }

  get ti => title;
  get con => content;
}