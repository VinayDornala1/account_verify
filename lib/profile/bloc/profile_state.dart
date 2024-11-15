part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final Map<String, dynamic>? user;
  ProfileLoadedState({required this.user});
}

final class UploadPicSuccess extends ProfileState {
  final String path;
  UploadPicSuccess({required this.path});
}

final class ProfileEditSuccess extends ProfileState {}

final class DeleteUserSuccess extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState({required this.error});
}

final class LogoutSuccess extends ProfileState {}
