import 'package:bloc/bloc.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBlocBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginBlocBloc() : super(LoginBlocInitial()) {
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }
  Future<void> _login(LoginEvent event, Emitter<LoginBlocState> emit) async {
    bool stateofLogin = false;
    emit(LoginBlocLoading());
    try {
      if (event.email == "1" && event.password == "1") {
        stateofLogin = true;
      }
    } catch (e) {
      print("error while login");
    }
    emit(LoginBlocLoaded(stateofLogin));
  }

  Future<void> _logout(LogoutEvent event, Emitter<LoginBlocState> emit) async {
    try {
      emit(LoginBlocLoading());
      // Update the state based on the event's data
      emit(LoginBlocLoaded(false));
    } catch (e) {
      emit(LoginBlocError('Error updating login status'));
    }
  }
}
