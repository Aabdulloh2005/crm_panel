import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
import 'package:lesson_101/bloc/user/user_bloc.dart';
import 'package:lesson_101/core/get_it.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          IconButton(
            onPressed: () {
              getIt.get<AuthBloc>().add(AuthLogout());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: context.read<UserBloc>()..add(GetUserEvent()),
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UserError) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is UserLoaded) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back, ${state.userModel.name}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("statelarga tushmadi"),
            );
          }
        },
      ),
    );
  }
}
