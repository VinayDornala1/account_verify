import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartTimer>(_onStartTimer);
    on<SplashEventCheckUser>(checkUser);
  }

  _onStartTimer(StartTimer event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashLoaded());
  }

  checkUser(SplashEventCheckUser event, Emitter<SplashState> emit) async {
    SharedPreferences userDetails = await SharedPreferences.getInstance();
    final id = userDetails.getString("userId");
    if (id == null) {
      emit(SplashFailedState());
    } else if (id.toString() == "null") {
      emit(SplashFailedState());
    } else {
      emit(SplashHasUserDetails(
        userId: int.parse(id),
      ));
    }
  }
}
