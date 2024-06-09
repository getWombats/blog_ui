import 'package:blog_ui/models/blog_post_dto.dart';

class BlogPost {
  String titel;
  String text;

  BlogPost(this.titel, this.text);

  factory BlogPost.fromDto(BlogPostDto dto) {
    return BlogPost(dto.title, dto.content);
  }
}