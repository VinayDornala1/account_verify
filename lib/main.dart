import 'package:account_verify/login/bloc/login_bloc.dart';
import 'package:account_verify/profile/bloc/profile_bloc.dart';
import 'package:account_verify/registration/bloc/registration_bloc.dart';
import 'package:account_verify/splash/bloc/splash_bloc.dart';
import 'package:account_verify/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SplashBloc(),
        ),
        BlocProvider(
          create: (_) => RegistrationBloc(),
        ),
        BlocProvider(
          create: (_) => LoginBloc(),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Registration App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
