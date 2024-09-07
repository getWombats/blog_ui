import 'package:blog_test/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

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
              AppConstants.APP_NAME,
              style: TextStyle(
                color: theme.colorScheme.surface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Version: 0.0.0.0.0.0.00001',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                // Text(
                //   'This app is designed to demonstrate my awesome skills in Flutter. And also to show how to communicate with my even more awesome quarkus rest api.',
                //   style: TextStyle(fontSize: 16),
                // ),
                // SizedBox(height: 24),
                Text(
                  'Not so fun fact: it took 278 cups of coffee to make this app and i lost all my hair',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.surface,
                backgroundColor: theme.colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Got it',
                style: TextStyle(
                  color: theme.colorScheme.surface,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
