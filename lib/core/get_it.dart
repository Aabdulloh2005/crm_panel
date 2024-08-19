import 'package:auth_repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:lesson_101/bloc/auth/auth_bloc.dart';
final getIt = GetIt.instance;


void setUpAuth() {
  getIt.registerSingleton(AuthService());

  getIt.registerSingleton(AuthBloc(authService: getIt.get<AuthService>()));
}
