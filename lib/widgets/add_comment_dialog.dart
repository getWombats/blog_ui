import 'package:flutter/material.dart';

class AddCommentDialog extends StatefulWidget {
  final ThemeData theme;

  const AddCommentDialog({
    super.key,
    required this.theme,
  });

  @override
  State<AddCommentDialog> createState() => AddBCommentDialogState();
}

class AddBCommentDialogState extends State<AddCommentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  void onSaveTap(String content) {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, content);
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
              child: TextFormField(
                controller: commentController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Comment',
                  hintText: 'Enter your comment',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A comment without content? 🤔';
                  }
                  return null;
                },
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
                    onSaveTap(commentController.text);
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
