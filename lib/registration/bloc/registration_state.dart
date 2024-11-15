part of 'registration_bloc.dart';

@immutable
sealed class RegistrationState {}

final class RegistrationInitial extends RegistrationState {}

final class UploadImageSuccessState extends RegistrationState {
  final String image;
  UploadImageSuccessState({required this.image});
}

final class UploadImageFailedState extends RegistrationState {
  final String error;
  UploadImageFailedState({required this.error});
}

final class RegistrationLoading extends RegistrationState {}

final class RegistrationSuccessState extends RegistrationState {}

final class RegistrationFailedState extends RegistrationState {
  final String message;
  RegistrationFailedState({required this.message});
}
