import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/view/main_screen.dart';
import '../../login/cubit/auth_cubit.dart';
import '../../login/view/login_screen.dart';
import '../../profile/cubit/my_user_cubit.dart';
import '../../profile/view/form_sign_up.dart';

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
            return const MainScreen();
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








// import 'package:agro_xplore/Home/home/home.dart';
// import 'package:agro_xplore/screens/Auth/bloc/authentication_bloc.dart';
// import 'package:agro_xplore/screens/Auth/signin/signin.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:agro_xplore/assets/assets.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:animation_wrappers/animation_wrappers.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final AuthenticationBloc _authenticationBloc = AuthenticationBloc();

//   @override
//   void initState() {
//     super.initState();
//     _authenticationBloc.add(AuthAutoLoginEvent());
//   }

//   @override
//   void dispose() {
//     _authenticationBloc.close();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return BlocProvider(
//         create: (context) => _authenticationBloc,
//         child: BlocListener<AuthenticationBloc, AuthenticationState>(
//           listener: ((context, state) {
//             if (state is AuthLoggedState) {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => state.isLogged
//                           ? const HomeScreen()
//                           : const Signinscreen()));
//             }if(state is AuthErrorLoginState){
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const Signinscreen()));
//             }
//           }),
//           child: Scaffold(
//             body: FadedSlideAnimation(
//               beginOffset: const Offset(0, 0.3),
//               endOffset: const Offset(0, 0),
//               slideCurve: Curves.linearToEaseOut,
//               child: Stack(
//                 alignment: AlignmentDirectional.bottomCenter,
//                 children: [
//                   Container(
//                     height: size.height,
//                     foregroundDecoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black38,
//                               Theme.of(context).colorScheme.secondary
//                             ], begin: Alignment.topCenter)),
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(Assets.intro),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   LoadingAnimationWidget.staggeredDotsWave(
//                     color: Colors.white30,
//                     size: 100,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//     );
//   }
// }
