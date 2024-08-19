import 'package:flutter/material.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
import 'package:lesson_101/core/get_it.dart';
import 'package:lesson_101/ui/widgets/custom_button.dart';
import 'package:lesson_101/ui/widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isSend = false;

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isSend = true;
        });
        getIt.get<AuthBloc>().add(
              AuthResetPassword(textEditingController.text),
            );
        setState(() {
          isSend = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Password reset email sent')),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text('Error resetting password: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: textEditingController,
                labelText: "Email",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter your email";
                  } else {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return "Email is wrong";
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(
                  title: "Login",
                  onPressed: _validateAndSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
