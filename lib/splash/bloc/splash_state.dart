part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {}

class SplashHasUserDetails extends SplashState {
  final int userId;
  SplashHasUserDetails({required this.userId});
}

class SplashFailedState extends SplashState {}
