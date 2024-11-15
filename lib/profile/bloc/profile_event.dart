part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileDetailsEvent extends ProfileEvent {
  final int userId;
  GetProfileDetailsEvent({required this.userId});
}

class EditProfilePic extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String emailId;
  final String profilePath;
  final int userId;
  EditProfileEvent(
      {required this.firstName,
      required this.lastName,
      required this.mobileNumber,
      required this.emailId,
      required this.profilePath,
      required this.userId});
}

class UserLogout extends ProfileEvent {}

class DeleteUser extends ProfileEvent {
  final int id;
  DeleteUser({required this.id});
}
