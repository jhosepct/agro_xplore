
import 'package:agro_xplore/screens/Auth/bloc/authentication_bloc.dart';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agro_xplore/assets/assets.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: _authenticationBloc,
        listener: (context, state) {
          if (state is AuthLoadingState) {
            setState(() {
              _loading = true;
            });
          }
          if (state is AuthLoggedState) {
            setState(() {
              _loading = false;
            });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => state.isLogged
                        ? const NavigationScreen()
                        : const Signinscreen()));
          }
          if (state is AuthErrorLoginState) {
            setState(() {
              _loading = false;
              _errorMessage = 'Correo o contraseña incorrecto';
            });
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: size.height,
                  foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black38,
                            Theme.of(context).colorScheme.secondary
                          ],
                          begin: Alignment.topCenter)),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.intro),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Agro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Xplore',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Contraseña',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 20),
                      _loading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                _authenticationBloc.add(AuthLoginEmailEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ));
                              },
                              child: Text('Iniciar Sesión',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 15),
                              ),
                            ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Aquí podrías implementar la función de "Recuperar contraseña"
                        },
                        child: Text('¿Olvidaste tu contraseña?',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _authenticationBloc.add(AuthLoginGoogleEvent());
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google_button.png',
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text('Ingresar con Google',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
