import 'package:blog_test/logger.util.dart';
import 'package:blog_test/model/blog_api.dart';
import 'package:blog_test/model/blog_post.dart';
import 'package:flutter/material.dart';

enum BlogState { initial, loaded, error }

class BlogProvider extends ChangeNotifier {
  BlogState _state = BlogState.initial;
  List<BlogPost> _blogs = [];
  final log = getLogger();
  String errorMessage = '';

  BlogState get state => _state;
  List<BlogPost> get blogs => _blogs;

  Future<void> readBlogs() async {
    try {
      _blogs = await BlogApi.instance.getBlogs();
      _state = BlogState.loaded;
    } catch (e) {
      log.e('Error fetching blog posts: ${e.toString()}');
      errorMessage = e.toString();
      _state = BlogState.error;
    }
    notifyListeners();
  }

  Future<void> createBlog(String title, String content) async {
    try {
      final blog =
          await BlogApi.instance.addBlog(title: title, content: content);
      _blogs.add(blog);
      _state = BlogState.loaded;
    } catch (e) {
      log.e('Error creating blog post: ${e.toString()}');
      errorMessage = e.toString();
      _state = BlogState.error;
    }
    notifyListeners();
  }

  Future<void> deleteBlog(int blogId) async {
    try {
      await BlogApi.instance.deleteBlog(blogId: blogId);
      _blogs.removeWhere((blog) => blog.id == blogId);
      _state = BlogState.loaded;
    } catch (e) {
      log.e('Error deleting blog post: ${e.toString()}');
      errorMessage = e.toString();
      _state = BlogState.error;
    }
    notifyListeners();
  }

  Future<void> updateBlog(int blogId, String title, String content) async {
    try {
      final blog = await BlogApi.instance.patchBlog(
          blogId: blogId, title: title, content: content);
      final index = _blogs.indexWhere((blog) => blog.id == blogId);
      _blogs[index] = blog;
      _state = BlogState.loaded;
    } catch (e) {
      log.e('Error updating blog post: ${e.toString()}');
      errorMessage = e.toString();
      _state = BlogState.error;
    }
    notifyListeners();
  }

  Future<void> addCommentToBlog(int blogId, String comment) async {
    try {
      final addedComment = await BlogApi.instance.addComment(blogId: blogId, content: comment);
      final index = _blogs.indexWhere((blog) => blog.id == blogId);
      BlogPost blog = _blogs[index];
      blog.comments.add(addedComment);
      _state = BlogState.loaded;
    } catch (e) {
      log.e('Error adding comment to blog post: ${e.toString()}');
      errorMessage = e.toString();
      _state = BlogState.error;
    }
    notifyListeners();
  }
}
