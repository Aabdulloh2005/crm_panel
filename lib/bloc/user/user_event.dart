// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final String name;
  final String photoUrl;
  final String email;
  final String phone;
  const UpdateUserEvent({
    required this.name,
    required this.photoUrl,
    required this.email,
    required this.phone,
  });
}
