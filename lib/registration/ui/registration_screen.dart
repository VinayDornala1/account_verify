import 'package:account_verify/Helpers/custom_loader.dart';
import 'package:account_verify/login/ui/login_screen.dart';
import 'package:account_verify/registration/bloc/registration_bloc.dart';
import 'package:account_verify/Helpers/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationFailedState) {
            _showSnackBar(state.message, context);
          } else if (state is RegistrationSuccessState) {
            _showSnackBar(
                "Registration successfull. Please login to continue", context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Registration',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<RegistrationBloc>()
                                .add(UploadProfilePicEvent());
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: state is UploadImageSuccessState
                                ? state.image != ""
                                    ? FileImage(File(state.image))
                                    : null
                                : null,
                            child: state is UploadImageSuccessState
                                ? state.image == ""
                                    ? const Icon(Icons.add_a_photo,
                                        size: 50, color: Colors.white)
                                    : null
                                : const Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          label: 'First Name',
                          controller: firstNameController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          label: 'Last Name',
                          controller: lastNameController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          label: 'Mobile Number',
                          controller: mobileNumberController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          label: 'Email ID',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          label: 'Password',
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        TextFieldWidget(
                          label: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RegistrationBloc>().add(
                                RegisterUserEvent(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    mobileNumber: mobileNumberController.text,
                                    emailId: emailController.text,
                                    password: passwordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Register',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is RegistrationLoading) const CustomLoader(),
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
}
