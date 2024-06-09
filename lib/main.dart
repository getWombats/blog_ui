import 'package:blog_ui/constants/application_constants.dart' as constants;
import 'package:blog_ui/models/blog_post.dart';
import 'package:blog_ui/models/blog_post_dto.dart';
import 'package:blog_ui/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;

List<BlogPost> items = [];
bool isLoading = false;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 119, 255)),
        useMaterial3: true,
      ),
      home: const MyBlogList(title: 'Mob Programming'),
    );
  }
}

class MyBlogList extends StatefulWidget {
  const MyBlogList({super.key, required this.title});

  final String title;

  @override
  State<MyBlogList> createState() => _MyBlogListState();
}

class _MyBlogListState extends State<MyBlogList> {
  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  void postBlog() async {
    var randomTitle = WordPair.random();

    String title = "$randomTitle";
    String content =
        "Hello, in this blog we will talk about $randomTitle's silly name.";

    final uri = Uri.parse(constants.apiUrl);
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({"title": title, "content": content});

    isLoading = true;
    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == HttpStatus.created) {
        var responseBlog = BlogPostDto.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);

        setState(() {
          items.add(BlogPost(responseBlog.ti, responseBlog.con));
        });
      } else {
        throw Exception('Failed to save blog entry: ${response.statusCode}');
      }
    } catch (ex) {
      // handle exception
    } finally {
      isLoading = false;
    }
  }

  void fetchBlogs() async {
    final uri = Uri.parse(constants.apiUrl);

    if (items.isNotEmpty) {
      setState(() {
        items.clear();
      });
    }

    isLoading = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // Test loading spinner

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> blogList = json.decode(response.body);

        List<BlogPost> blogs = blogList
            .map((json) => BlogPost.fromDto(BlogPostDto.fromJson(json)))
            .toList();

        setState(() {
          items = blogs;
        });
      } else {
        throw Exception('Failed to load blog entries: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton(
        onPressed: postBlog,
        child: const Text("Add Blog Test"),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: fetchBlogs, child: const Text("Refresh Blogs Test")),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return BlogCard(blog: items[index]);
                    }),
          ),
        ],
      ),
    );
  }
}
