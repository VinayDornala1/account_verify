import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helpers/database_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(loginUser);
  }

  loginUser(LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    if (event.email == "") {
      emit(LoginFailureState(message: "Please enter emailId"));
    } else if (!isValidEmail(event.email)) {
      emit(LoginFailureState(message: "Please enter valid emailId"));
    } else if (event.password == "") {
      emit(LoginFailureState(message: "Please enter password"));
    } else if (event.password.length < 6) {
      emit(
          LoginFailureState(message: "Password must be at least 6 characters"));
    } else {
      final user = await DatabaseHelper().getUser(event.email, event.password);
      if (user != null) {
        SharedPreferences userDetails = await SharedPreferences.getInstance();
        userDetails.setString("userId", user['id'].toString());
        emit(LoginSuccessState(userId: user['id']));
      } else {
        emit(LoginFailureState(message: 'Invalid email or password'));
      }
    }
  }
}

bool isValidEmail(String email) {
  const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}
