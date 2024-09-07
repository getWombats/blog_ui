import 'dart:ui';

import 'package:blog_test/services/blog_provider.dart';
import 'package:blog_test/constants/app_constants.dart';
import 'package:blog_test/model/blog_post.dart';
import 'package:blog_test/widgets/add_comment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogDetailsView extends StatefulWidget {
  final BlogPost blog;

  const BlogDetailsView({super.key, required this.blog});

  @override
  BlogDetailsViewState createState() => BlogDetailsViewState();
}

class BlogDetailsViewState extends State<BlogDetailsView> {
  final TextEditingController _commentController = TextEditingController();
  final defaultTimeFormat =
      GlobalConfiguration().getValue(ConfigKeyName.DEFAULT_TIME_FORMAT);

  late BlogProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BlogProvider>(context, listen: false);
  }

  Future<void> _showAddCommentDialog(BuildContext context) async {
    final theme = Theme.of(context);
    var comment = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
            AddCommentDialog(
              theme: theme,
            )
          ]);
        });

    if (comment != null) {
      provider.addCommentToBlog(widget.blog.id, comment);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat formatter = DateFormat(defaultTimeFormat);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title),
      ),
      body: Consumer<BlogProvider>(builder: (context, blogProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blog.content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: widget.blog.comments.isEmpty
                    ? const Center(child: Text('No comments yet.'))
                    : ListView.builder(
                        itemCount: widget.blog.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.blog.comments[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('#${comment.commentNumber}'),
                                Text(comment.content),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Author: ${comment.author}'),
                                Text(
                                    'Created: ${formatter.format(comment.createdAt)}'),
                                if (comment.lastEditedAt != null)
                                  Text(
                                      'Last Edited: ${formatter.format(comment.lastEditedAt!)}'),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCommentDialog(context),
        tooltip: 'Add Comment',
        shape: const CircleBorder(),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
