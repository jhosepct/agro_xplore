import 'package:agro_xplore/firebase_options.dart';
import 'package:agro_xplore/login/cubit/auth_cubit.dart';
import 'package:agro_xplore/login/provider/auth.dart';
import 'package:agro_xplore/screens/Auth/splash_screen.dart';
import 'package:agro_xplore/screens/profile/cubit/my_user_cubit.dart';
import 'package:agro_xplore/screens/profile/provider/my_user_repository.dart';
import 'package:agro_xplore/style/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authCubit = AuthCubit(AuthRepository());
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => authCubit..init()),
    BlocProvider(create: (context) => MyUserCubit(MyUserRepository())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: uiTheme(),
        home: const SplashScreen());
  }
}