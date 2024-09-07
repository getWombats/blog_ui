import 'dart:ui';

import 'package:blog_test/services/blog_provider.dart';
import 'package:blog_test/widgets/add_blog_dialog.dart';
import 'package:blog_test/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  BlogListViewState createState() => BlogListViewState();
}

class BlogListViewState extends State<BlogListView> {
  late BlogProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BlogProvider>(context, listen: false);
    Future.microtask(() => provider.readBlogs());
  }

  Future<void> _refreshBlogs() async {
    await provider.readBlogs();
  }

  Future<void> _showAddBlogDialog(BuildContext context) async {
    final theme = Theme.of(context);
    var babyBlogPost = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
            AddBlogDialog(
              theme: theme,
            )
          ]);
        });

    if (babyBlogPost != null) {
      String title = babyBlogPost['title'];
      String content = babyBlogPost['content'];

      await provider.createBlog(title, content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshBlogs,
            child: Column(
              children: [
                if (blogProvider.state == BlogState.initial)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (blogProvider.state == BlogState.error)
                  Expanded(
                    child: Center(child: Text(blogProvider.errorMessage)),
                  ),
                if (blogProvider.state == BlogState.loaded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: blogProvider.blogs.isEmpty
                          ? 1
                          : blogProvider.blogs.length,
                      itemBuilder: (context, index) {
                        if (blogProvider.blogs.isEmpty) {
                          return const Center(child: Text('No blogs found'));
                        }
                        final blog = blogProvider.blogs[index];
                        return BlogCard(blog: blog);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            _showAddBlogDialog(context);
          },
          backgroundColor: theme.colorScheme.primary,
          child: Icon(
            Icons.add,
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
