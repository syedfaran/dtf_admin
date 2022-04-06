import 'package:dtf_web/constants/app_string.dart';
import 'package:dtf_web/state_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    switch (provider.loginState) {
      case ApplicationLoginState.loggedOut:
        return Center(
          child: OutlinedButton(
              child: const Text('Google'),
              onPressed: () {
                provider.signInWithGoogle((e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text(AppString.errorText)));
                });
              }),
        );
      case ApplicationLoginState.loggedIn:
        return const Center(child: Text('Main'));
    }
  }
}
