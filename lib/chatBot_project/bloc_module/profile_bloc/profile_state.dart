// States
import 'dart:io';

abstract class EditProfileState{
  const EditProfileState();

  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileUpdated extends EditProfileState {
  final String name;
  final String username;
  final String password;
  final String areaOfInterest;
  final String wantToBecome;
  final bool isPrivate;
  final File? avatar;

  const EditProfileUpdated({
    required this.name,
    required this.username,
    required this.password,
    required this.areaOfInterest,
    required this.wantToBecome,
    required this.isPrivate,
    required this.avatar,
  });

  @override
  List<Object?> get props => [
        name,
        username,
        password,
        areaOfInterest,
        wantToBecome,
        isPrivate,
        avatar
      ];
}