part of 'login_bloc_bloc.dart';

abstract class LoginBlocState {}

final class LoginBlocInitial extends LoginBlocState {}

final class LoginBlocLoading extends LoginBlocState {}

final class LoginBlocLoaded extends LoginBlocState {
  bool isloged;
  LoginBlocLoaded(this.isloged);
}

final class LoginBlocError extends LoginBlocState {
  final String message;
  LoginBlocError(this.message);
}
