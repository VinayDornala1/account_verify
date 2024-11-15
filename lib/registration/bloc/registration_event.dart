part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String emailId;
  final String password;
  final String confirmPassword;
  RegisterUserEvent(
      {required this.firstName,
      required this.lastName,
      required this.mobileNumber,
      required this.emailId,
      required this.password,
      required this.confirmPassword});
}

class UploadProfilePicEvent extends RegistrationEvent {}
