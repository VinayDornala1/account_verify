part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {}

class StartTimer extends SplashEvent {}

class SplashEventCheckUser extends SplashEvent {}
