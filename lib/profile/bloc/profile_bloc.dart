import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helpers/database_helper.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(loadUserDetails);
    on<EditProfileEvent>(updateProfile);
    on<UserLogout>(userLogout);
    on<DeleteUser>(deleteProfile);
    on<EditProfilePic>(editProfilePic);
  }

  loadUserDetails(
      GetProfileDetailsEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final user = await _dbHelper.getUserById(event.userId);
      if (user != null) {
        emit(ProfileLoadedState(user: user));
      } else {
        emit(ProfileErrorState(error: "Something Went Wrong"));
      }
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
    }
  }

  editProfilePic(EditProfilePic event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String profilePhoto = image.path;
      emit(UploadPicSuccess(path: profilePhoto));
    } else {
      emit(ProfileErrorState(error: "Unable to upload photo"));
    }
  }

  updateProfile(EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final updatedUser = {
        'first_name': event.firstName,
        'last_name': event.lastName,
        'mobile_number': event.mobileNumber,
        'email': event.emailId,
        'profile_photo': event.profilePath,
      };
      await _dbHelper.updateUser(event.userId, updatedUser);
      emit(ProfileEditSuccess());
    } catch (e) {
      ProfileErrorState(error: "Something Went Wrong");
    }
  }

  userLogout(UserLogout event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    SharedPreferences userDetails = await SharedPreferences.getInstance();
    userDetails.clear();
    emit(LogoutSuccess());
  }

  deleteProfile(DeleteUser event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await _dbHelper.deleteUser(event.id);
      emit(DeleteUserSuccess());
    } catch (e) {
      emit(ProfileErrorState(error: "Something Went Wrong"));
    }
  }
}
