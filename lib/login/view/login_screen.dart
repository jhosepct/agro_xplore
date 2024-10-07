import 'package:agro_xplore/login/widgets/glassmorphic_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:investi_go/widgets/neumorphic_button.dart';
import '../../login/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const LoginScreen();
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final isSigningIn = context.watch<AuthCubit>().state is AuthSigningIn;

    return Scaffold(
      body: AbsorbPointer(
        absorbing: isSigningIn,
        child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/intro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('AgroXplore the best application for your crops',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black87,
                                  offset: Offset(5.0, 5.0),
                                ),
                              ],
                            )),
                  ),
                  (isSigningIn)
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AuthCubit>().signInWithGoogle();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/google_button.png',
                                          height: 40,
                                          width: 40,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Text('Sign up with Google',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black))
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              GlassBox(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Text('Other sign in options',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
