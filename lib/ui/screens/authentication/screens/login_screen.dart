import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
import 'package:lesson_101/core/get_it.dart';
import 'package:lesson_101/ui/screens/authentication/screens/register_screen.dart';
import 'package:lesson_101/ui/screens/authentication/screens/reset_password_screen.dart';
import 'package:lesson_101/ui/screens/authentication/widgets/social_button.dart';
import 'package:lesson_101/ui/widgets/custom_button.dart';
import 'package:lesson_101/ui/widgets/custom_text.dart';
import 'package:lesson_101/ui/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!value.contains(RegExp(r'[a-z]')) ||
        !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign in to WoorkRoom',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Gap(40),
                          CustomTextFormField(
                            keyboardType: TextInputType.number,
                            validator: validateEmail,
                            controller: emailController,
                            labelText: "Phone",
                            hintText: "Enter phone",
                          ),
                          const Gap(16),
                          CustomTextFormField(
                            validator: validatePassword,
                            controller: passwordController,
                            labelText: "Password",
                            hintText: "Enter password",
                          ),
                          const Gap(8),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen(),
                              ));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange,
                            ),
                            child: const Text('Forgot Password?'),
                          ),
                          const Gap(24),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              title: "Sign in",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  getIt.get<AuthBloc>().add(
                                        AuthSignIn(emailController.text,
                                            passwordController.text),
                                      );
                                }
                              },
                            ),
                          ),
                          const Gap(24),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomText(
                                  text: "Or Sign in With",
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(
                                  assetName: 'assets/images/google.png'),
                              Gap(16),
                              SocialButton(
                                  assetName: 'assets/images/facebook.png'),
                            ],
                          ),
                          const Gap(40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Sign up',
                                    style: TextStyle(color: Colors.orange)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
