import 'package:agro_xplore/home/view/main_screen.dart';
import 'package:agro_xplore/login/cubit/auth_cubit.dart';
import 'package:agro_xplore/screens/profile/provider/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/my_user_cubit.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  bool isEditting = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(me.name,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    const SizedBox(height: 8),
                    // Visibility(
                    //   visible: !isEditting,
                    //   child: FloatingActionButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         isEditting = true;
                    //       });
                    //     },
                    //     child: const Icon(Icons.edit),
                    //   ),
                    // ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange)),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: const Text('¿Cerrar sesion?'),
                                  content: const Text(
                                      '¿Estas seguro que deseas salir de AgroXplore?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await context
                                            .read<AuthCubit>()
                                            .signOut()
                                            .then((value) {
                                          context.read<MyUserCubit>().logOut();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Si'),
                                    ),
                                  ],
                                ));
                      },
                      child: const Text('Cerrar cuenta'),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: const Text(
                                      '¿Estas seguro que deseas Eliminar tu cuenta?'),
                                  content: const Text(
                                      'Si eliminas tu cuenta se borraran todos tus datos registrados.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.red)),
                                      onPressed: () async {
                                        await firebaseProvider.eliminarCuenta();
                                        // ignore: use_build_context_synchronously
                                        await context
                                            .read<AuthCubit>()
                                            .signOut()
                                            .then((value) {
                                          context.read<MyUserCubit>().logOut();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ));
                      },
                      child: const Text('Eliminar cuenta'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
