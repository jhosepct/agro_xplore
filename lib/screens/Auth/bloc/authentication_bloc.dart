import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import "package:meta/meta.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthLoginEmailEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        print('User: ${userCredential.user!.email}');

        // Guardar el estado de autenticación localmente
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogged', true);

        emit(const AuthLoggedState(isLogged: true));
      } on Exception catch (e) {
        emit(AuthErrorLoginState(authErrorMessage: e.toString()));
      }
    });

    on<AuthLoginGoogleEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          UserCredential userCredential =
          await _auth.signInWithCredential(credential);
          print('User: ${userCredential.user!.email}');

          // Guardar el estado de autenticación localmente
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLogged', true);

          emit(const AuthLoggedState(isLogged: true));
        } else {
          print("FALOOOOOOO LA AUTENTICACION");
          emit(const AuthErrorLoginState(
              authErrorMessage: 'Google sign in failed'));
        }
      } on Exception catch (e) {
        emit(AuthErrorLoginState(authErrorMessage: e.toString()));
      }
    });

    on<AuthAutoLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        var connectivityResult = await (Connectivity().checkConnectivity());

        if (connectivityResult == ConnectivityResult.none) {
          // Sin conexión, verificar el estado de autenticación localmente
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          bool? isLogged = prefs.getBool('isLogged');

          if (isLogged != null && isLogged == true) {
            emit(const AuthLoggedState(isLogged: true));
          } else {
            emit(const AuthErrorLoginState(
                authErrorMessage:
                'No user logged in and no internet connection'));
          }
        } else {
          // Con conexión, verificar con Firebase
          User? user = _auth.currentUser;
          if (user != null) {
            // Guardar estado local
            final SharedPreferences prefs =
            await SharedPreferences.getInstance();
            await prefs.setBool('isLogged', true);

            emit(const AuthLoggedState(isLogged: true));
          } else {
            emit(const AuthErrorLoginState(
                authErrorMessage: 'No user logged in'));
          }
        }
      } on Exception catch (e) {
        emit(AuthErrorLoginState(authErrorMessage: e.toString()));
      }
    });

    on<AuthLogOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        await _auth.signOut();

        // Borrar el estado de autenticación localmente
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogged', false);

        emit(AuthLogOutState());
        // emit(const AuthErrorLoginState(
        //         authErrorMessage: 'No user logged in'));
      } on Exception catch (e) {
        emit(AuthErrorLoginState(authErrorMessage: e.toString()));
      }
    });
  }
}