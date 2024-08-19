import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
import 'package:lesson_101/core/get_it.dart';
import 'package:lesson_101/ui/screens/authentication/screens/login_screen.dart';
import 'package:lesson_101/ui/screens/main_screen.dart';
import 'package:toastification/toastification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _loadNextPage();
  }

  void _loadNextPage() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return BlocConsumer(
                bloc: getIt.get<AuthBloc>()..add(CheckTokenExpiry()),
                listener: (context, state) {
                  if (state is AuthLoading) {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is AuthUnauthenticated) {
                    Navigator.of(context).pop();
                  }
                  if (state is AuthError) {
                    Navigator.of(context).pop();

                    toastification.show(
                      closeOnClick: true,
                      autoCloseDuration: const Duration(seconds: 2),
                      showProgressBar: true,
                      title: Text(state.message),
                      type: ToastificationType.error,
                    );
                  }
                  if (state is AuthAuthenticated) {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return const MainScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              );
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1, -0.1);
              const end = Offset.zero;
              const curve = Curves.linear;
              dynamic tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              dynamic offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }

  void _startAnimation() async {
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 1),
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/images/logo.png',
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
