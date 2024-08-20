import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lesson_101/data/models/user_model.dart';
import 'package:lesson_101/data/service/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserService userService = UserService();
  UserBloc() : super(UserInitial()) {
    on<GetUserEvent>(_onGetUserEvent);
  }

  _onGetUserEvent(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userModel = await userService.getUser();

      emit(
        UserLoaded(userModel: userModel),
      );
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }
}
