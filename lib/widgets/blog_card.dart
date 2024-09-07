import 'package:blog_test/constants/app_constants.dart';
import 'package:blog_test/model/blog_post.dart';
import 'package:blog_test/widgets/blog_details_view.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatelessWidget {
  final BlogPost blog;
  final defaultTimeFormat =
      GlobalConfiguration().getValue(ConfigKeyName.DEFAULT_TIME_FORMAT);

  BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat formatter = DateFormat(defaultTimeFormat);
    var blogCreationTime = formatter.format(blog.createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              blog.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created: $blogCreationTime',
                      style: TextStyle(
                          fontSize: 12, color: theme.colorScheme.secondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Author: ${blog.author}',
                      style: TextStyle(
                          fontSize: 12, color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailsView(blog: blog),
                      ),
                    );
                  },
                  child: const Text('Read More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
