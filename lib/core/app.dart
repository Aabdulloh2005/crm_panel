import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
import 'package:lesson_101/bloc/user/user_bloc.dart';
import 'package:lesson_101/core/get_it.dart';
import 'package:lesson_101/ui/screens/authentication/screens/splash_screen.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider.value(value: getIt.get<AuthBloc>()),
      ],
      child: const ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
