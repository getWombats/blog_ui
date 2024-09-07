import 'dart:convert';
import 'dart:io';
import 'package:blog_test/constants/app_constants.dart';
// import 'package:blog_test/services/storage_service.dart';
import 'package:blog_test/model/blog_post.dart';
import 'package:blog_test/model/comment.dart';
import 'package:blog_test/services/auth_provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class BlogApi {
  static BlogApi instance = BlogApi._privateConstructor();
  BlogApi._privateConstructor();

  static const String _blogsPath = 'blogs';
  
  static final String _baseUrl =
      '${Platform.isAndroid ? GlobalConfiguration().getValue(ConfigKeyName.LOCAL_IP_ANDROID) : GlobalConfiguration().getValue(ConfigKeyName.LOCAL_IP)}:${GlobalConfiguration().getValue(ConfigKeyName.API_PORT)}';

  // static final _storageService = StorageService.instance;

  static final authHeaders = {
    'Content-Type': 'application/json',
    'Author': AuthState.instance.userInfo.username,
    // 'Authorization':
    //     'Bearer ${_storageService.readValue(TokenKeyName.ACCESS_TOKEN)}',
  };

  Future<List<BlogPost>> getBlogs() async {
    try {
      final response = await http.get(
        Uri.http(_baseUrl, _blogsPath),
      );
      if (response.statusCode == HttpStatusCode.OK) {
        final List<dynamic> blogsJson = jsonDecode(response.body);
        var blogs = blogsJson.map((json) => BlogPost.fromJson(json)).toList();
        return blogs;
      } else {
        if(response.statusCode >= 500) {
          throw Exception('Server error. Please try again later.');
        }

        if(response.statusCode == HttpStatusCode.NOT_FOUND){
          return [];
        }

        throw Exception(
            'Failed to load blogs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // throw Exception('Failed to load blogs');
      throw Exception(e.toString());
    }
  }

  Future<BlogPost> getBlog({required int blogId}) async {
    try {
      final response = await http.get(
        Uri.http(_baseUrl, "$_blogsPath/$blogId"),
      );
      if (response.statusCode == HttpStatusCode.OK) {
        final Map<String, dynamic> blogJson = jsonDecode(response.body);
        return BlogPost.fromJson(blogJson);
      } else {
        throw Exception(
            'Failed to load blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load blog');
    }
  }

  Future<BlogPost> addBlog(
      {required String title, required String content}) async {
    try {
      final response = await http.post(
        Uri.http(_baseUrl, _blogsPath),
        headers: authHeaders,
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );
      if (response.statusCode == HttpStatusCode.CREATED) {
        final Map<String, dynamic> blogJson = jsonDecode(response.body);
        return BlogPost.fromJson(blogJson);
      } else {
        throw Exception(
            'Failed to create blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create blog');
      // throw Exception(e.toString());
    }
  }

  Future<BlogPost> patchBlog(
      {required int blogId, String? title, String? content}) async {
    var patchBody = {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
    };
    try {
      final response = await http.patch(
        Uri.http(_baseUrl, "$_blogsPath/$blogId"),
        headers: authHeaders,
        body: jsonEncode(patchBody),
      );
      if (response.statusCode == HttpStatusCode.OK) {
        final Map<String, dynamic> blogJson = jsonDecode(response.body);
        return BlogPost.fromJson(blogJson);
      } else {
        throw Exception(
            'Failed to update blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update blog');
    }
  }

  Future<void> deleteBlog({required int blogId}) async {
    try {
      final response = await http.delete(
        Uri.http(_baseUrl, "$_blogsPath/$blogId"),
        headers: authHeaders,
      );
      if (response.statusCode != HttpStatusCode.NO_CONTENT) {
        throw Exception(
            'Failed to delete blog. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete blog');
    }
  }

  Future<Comment> addComment(
      {required int blogId, required String content}) async {
    try {
      final response = await http.post(
        Uri.http(_baseUrl, "$_blogsPath/$blogId/comments"),
        headers: authHeaders,
        body: jsonEncode({
          'content': content,
        }),
      );
      if (response.statusCode == HttpStatusCode.CREATED) {
        final Map<String, dynamic> commentJson = jsonDecode(response.body);
        return Comment.fromJson(commentJson);
      } else {
        throw Exception(
            'Failed to create comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create comment');
    }
  }
}
