import 'package:flutter/material.dart';

class AddBlogDialog extends StatefulWidget {
  final ThemeData theme;

  const AddBlogDialog({
    super.key,
    required this.theme,
  });

  @override
  State<AddBlogDialog> createState() => _AddBlogDialogState();
}

class _AddBlogDialogState extends State<AddBlogDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController blogTitleController = TextEditingController();
  final TextEditingController blogContentController = TextEditingController();

  void onSaveTap(String title, String content) {
    if (_formKey.currentState!.validate()) {
      Map<String, String> babyBlogPost = {'title': title, 'content': content};
      Navigator.pop(context, babyBlogPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              'Create a new blog post',
              style: TextStyle(
                color: widget.theme.colorScheme.surface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              color: widget.theme.colorScheme.surface,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: blogTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter the title of your blog post',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A blog post without a title? 🤔';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: blogContentController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Content',
                      hintText: 'Enter the content of your blog post',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A blog post without content? 🤔';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CANCEL")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0.0, 16.0, 0.0),
                child: ElevatedButton(
                  onPressed: () {
                    onSaveTap(
                        blogTitleController.text, blogContentController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: widget.theme.colorScheme.surface,
                    backgroundColor: widget.theme.colorScheme.primary,
                  ),
                  child: const Text("SAVE"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
