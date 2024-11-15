import 'dart:io';

import 'package:account_verify/Helpers/custom_loader.dart';
import 'package:account_verify/Helpers/widgets/textfieldWidget.dart';
import 'package:account_verify/login/ui/login_screen.dart';
import 'package:account_verify/profile/bloc/profile_bloc.dart';
import 'package:account_verify/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String profilePhotoPath = '';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ProfileBloc>()
        .add(GetProfileDetailsEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            final user = state.user;
            firstNameController.text = user?['first_name'];
            lastNameController.text = user?['last_name'];
            mobileNumberController.text = user?['mobile_number'];
            emailController.text = user?['email'];
            profilePhotoPath = user?['profile_photo'];
          } else if (state is ProfileEditSuccess) {
            isEditing = false;
            context
                .read<ProfileBloc>()
                .add(GetProfileDetailsEvent(userId: widget.userId));
          } else if (state is ProfileErrorState) {
            _showSnackBar(state.error, context);
          } else if (state is LogoutSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          } else if (state is DeleteUserSuccess) {
            _showSnackBar("Delete profile successfully!", context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          } else if (state is UploadPicSuccess) {
            profilePhotoPath = state.path;
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 20, right: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            isEditing
                                ? const SizedBox()
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditing = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade100),
                                    child: const Text("Edit"),
                                  )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isEditing) {
                            context.read<ProfileBloc>().add(EditProfilePic());
                          } else {}
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profilePhotoPath.isNotEmpty
                              ? FileImage(File(profilePhotoPath))
                              : const AssetImage('assets/profile.png'),
                          child: isEditing
                              ? const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'First Name',
                        controller: firstNameController,
                        enabled: isEditing,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'Last Name',
                        controller: lastNameController,
                        enabled: isEditing,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'Mobile Number',
                        controller: mobileNumberController,
                        enabled: isEditing,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: 'Email ID',
                        controller: emailController,
                        enabled: isEditing,
                      ),
                      const SizedBox(height: 30),
                      isEditing
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(UserLogout());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100),
                              child: const Text("Logout"),
                            ),
                      isEditing ? const SizedBox() : const SizedBox(height: 30),
                      isEditing
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                showDeleteAccountDialog();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100),
                              child: const Text("Delete Profile"),
                            ),
                      isEditing
                          ? ElevatedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(
                                    EditProfileEvent(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        mobileNumber:
                                            mobileNumberController.text,
                                        emailId: emailController.text,
                                        profilePath: profilePhotoPath,
                                        userId: widget.userId));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade100),
                              child: const Text("Save"),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
              if (state is ProfileLoadingState) const CustomLoader()
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  showDeleteAccountDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Confirm Deletion",
            ),
            content: const SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Are you sure you want to delete your account?"),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<ProfileBloc>()
                        .add(DeleteUser(id: widget.userId));
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }
}
