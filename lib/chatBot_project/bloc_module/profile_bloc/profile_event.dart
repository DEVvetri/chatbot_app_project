import 'dart:io';

abstract class EditProfileEvent {}

class UpdateName extends EditProfileEvent {
  final String name;
  UpdateName(this.name);
}

class UpdateUsername extends EditProfileEvent {
  final String username;
  UpdateUsername(this.username);
}

class UpdatePassword extends EditProfileEvent {
  final String password;
  UpdatePassword(this.password);
}

class UpdateAreaOfInterest extends EditProfileEvent {
  final String areaOfInterest;
  UpdateAreaOfInterest(this.areaOfInterest);
}

class UpdateWantToBecome extends EditProfileEvent {
  final String wantToBecome;
  UpdateWantToBecome(this.wantToBecome);
}

class UpdatePrivate extends EditProfileEvent {
  final bool isPrivate;
  UpdatePrivate(this.isPrivate);
}

class UpdateAvatar extends EditProfileEvent {
  final File? avatar;
  UpdateAvatar(this.avatar);
}

class SaveProfileEvent extends EditProfileEvent {
  final String name;
  final String username;
  final String password;
  final String areaOfInterest;
  final String wantToBecome;
  final bool isPrivate;
  final File? avatar;

  SaveProfileEvent({
    required this.name,
    required this.username,
    required this.password,
    required this.areaOfInterest,
    required this.wantToBecome,
    required this.isPrivate,
    this.avatar,
  });
}
