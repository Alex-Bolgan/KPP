import 'package:flutter/material.dart';
import 'package:expense_tracker/utilities/app_strings.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: AppStrings.emailLabel,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.emailEmptyError;
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppStrings.emailInvalidError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.passwordLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.passwordEmptyError;
                  } else if (value.length < 6) {
                    return AppStrings.passwordLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text(AppStrings.loginButton),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.registerNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}