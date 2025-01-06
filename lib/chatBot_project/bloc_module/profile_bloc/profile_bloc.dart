// Bloc
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_event.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc()
      : super(EditProfileUpdated(
          name: 'vetrivel',
          username: 'vv_vetri',
          password: '123456789',
          areaOfInterest: 'software development',
          wantToBecome: 'software developer',
          isPrivate: false,
          avatar: null,
        )) {
    on<UpdateName>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(name: event.name));
    });

    on<UpdateUsername>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(username: event.username));
    });

    on<UpdatePassword>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(password: event.password));
    });

    on<UpdateAreaOfInterest>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(areaOfInterest: event.areaOfInterest));
    });

    on<UpdateWantToBecome>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(wantToBecome: event.wantToBecome));
    });

    on<UpdatePrivate>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(isPrivate: event.isPrivate));
    });

    on<UpdateAvatar>((event, emit) {
      final currentState = state as EditProfileUpdated;
      emit(currentState.copyWith(avatar: event.avatar));
    });

    on<SaveProfileEvent>((event, emit) {
      emit(EditProfileUpdated(
        name: event.name,
        username: event.username,
        password: event.password,
        areaOfInterest: event.areaOfInterest,
        wantToBecome: event.wantToBecome,
        isPrivate: event.isPrivate,
        avatar: event.avatar,
      ));
    });
  }
}

// Extension for state copying
extension EditProfileStateCopyWith on EditProfileUpdated {
  EditProfileUpdated copyWith({
    String? name,
    String? username,
    String? password,
    String? areaOfInterest,
    String? wantToBecome,
    bool? isPrivate,
    File? avatar,
  }) {
    return EditProfileUpdated(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      areaOfInterest: areaOfInterest ?? this.areaOfInterest,
      wantToBecome: wantToBecome ?? this.wantToBecome,
      isPrivate: isPrivate ?? this.isPrivate,
      avatar: avatar ?? this.avatar,
    );
  }
}
