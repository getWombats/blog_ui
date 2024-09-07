import 'package:blog_test/constants/app_constants.dart';
import 'package:blog_test/logger.util.dart';
import 'package:blog_test/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final clientId = GlobalConfiguration().getValue(ConfigKeyName.CLIENT_ID);
  final log = getLogger();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _authenticate() async {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;
      bool loginSuccess;

      try {
        // cant believe i am doing this... but i have to
        loginSuccess = await AuthState.instance.tryLogin(username, password);

        if (loginSuccess && mounted) {
          usernameController.clear();
          passwordController.clear();

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MainScreen(title: AppConstants.APP_NAME),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                var fadeInAnimation =
                    Tween(begin: 0.0, end: 1.0).animate(animation);
                var fadeOutAnimation =
                    Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation);

                return FadeTransition(
                  opacity: fadeInAnimation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: fadeOutAnimation,
                      child: child,
                    ),
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 250),
            ),
          );
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: false,
                content:
                    const Text('Login failed. Check username or password.'),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            );
          });
        }
      } catch (e) {
        log.e('Login Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: theme.colorScheme.primary,
                  child: Center(
                    child: Text(
                      AppConstants.APP_NAME,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Card(
                elevation: 20,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle:
                                TextStyle(color: theme.colorScheme.primary),
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person,
                                color: theme.colorScheme.primary),
                          ),
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: theme.colorScheme.primary),
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock,
                                color: theme.colorScheme.primary),
                          ),
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _authenticate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                            ),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color: theme.colorScheme.surface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
