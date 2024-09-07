import 'package:blog_test/services/blog_provider.dart';
import 'package:blog_test/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

void main() async {
  Logger.level = Level.debug;
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("dev_settings");

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    return const Center(
      child: Text(
        "An error occurred.",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 20,
        ),
      ),
    );
  };

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BlogProvider()),
    ],
    child: const TheDevBlogApp(),
  ));
}

class TheDevBlogApp extends StatelessWidget {
  const TheDevBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 162, 0, 255)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
