import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../Helpers/database_helper.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  String profilePhoto = "";
  RegistrationBloc() : super(RegistrationInitial()) {
    on<UploadProfilePicEvent>(pickImage);
    on<RegisterUserEvent>(registerUser);
  }

  registerUser(RegisterUserEvent event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    if (profilePhoto == "") {
      emit(RegistrationFailedState(message: "Please add profile photo"));
    } else if (event.firstName == "") {
      emit(RegistrationFailedState(message: "Please enter first name"));
    } else if (event.lastName == "") {
      emit(RegistrationFailedState(message: "Please enter last name"));
    } else if (event.mobileNumber == "") {
      emit(RegistrationFailedState(message: "Please enter mobileNumber"));
    } else if (event.mobileNumber.length < 10) {
      emit(RegistrationFailedState(message: "Please enter valid mobileNumber"));
    } else if (event.emailId == "") {
      emit(RegistrationFailedState(message: "Please enter emailId"));
    } else if (!isValidEmail(event.emailId)) {
      emit(RegistrationFailedState(message: "Please enter valid emailId"));
    } else if (event.password == "") {
      emit(RegistrationFailedState(message: "Please enter password"));
    } else if (event.password.length < 6) {
      emit(RegistrationFailedState(
          message: "Password must be at least 6 characters"));
    } else if (event.confirmPassword == "") {
      emit(RegistrationFailedState(message: "Please enter confirm password"));
    } else if (event.password != event.confirmPassword) {
      emit(RegistrationFailedState(
          message: "Password and Confirm password didn't match"));
    } else {
      try {
        await DatabaseHelper().insertUser({
          'first_name': event.firstName,
          'last_name': event.lastName,
          'mobile_number': event.mobileNumber,
          'email': event.emailId,
          'password': event.password,
          'profile_photo': profilePhoto,
        }).then((value) {
          emit(RegistrationSuccessState());
        });
      } catch (e) {
        emit(RegistrationFailedState(message: e.toString()));
      }
    }
  }

  pickImage(
      UploadProfilePicEvent event, Emitter<RegistrationState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profilePhoto = image.path;
      print("profilephoto...$profilePhoto");
      emit(UploadImageSuccessState(image: profilePhoto));
    } else {
      emit(UploadImageFailedState(error: "Unable to upload photo"));
    }
  }

  bool isValidEmail(String email) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
