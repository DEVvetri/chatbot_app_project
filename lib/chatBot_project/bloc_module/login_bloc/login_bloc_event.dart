part of 'login_bloc_bloc.dart';

abstract class LoginBlocEvent {}

class LoginEvent extends LoginBlocEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class CreateUser extends LoginBlocEvent {
  final String email;
  final String password;
  final String userName;
  CreateUser(
      {required this.email, required this.password, required this.userName});
}

class LogoutEvent extends LoginBlocEvent {}
