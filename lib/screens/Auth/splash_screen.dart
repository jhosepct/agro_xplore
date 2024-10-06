import 'package:agro_xplore/login/cubit/auth_cubit.dart';
import 'package:agro_xplore/login/view/login_screen.dart';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:agro_xplore/screens/profile/cubit/my_user_cubit.dart';
import 'package:agro_xplore/screens/profile/view/form_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      return BlocBuilder<MyUserCubit, MyUserState>(
          builder: (context, myUserState) {
            if (authState is AuthSignedIn) {
              context.read<MyUserCubit>().validarNuevo();
              if (myUserState is NewUserState) {
                return const FormSignUp();
              } else if (myUserState is MyUserReadyState) {
                return const NavigationScreen();
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const LoginScreen();
          });
    });
  }
}
