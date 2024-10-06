// import 'dart:io';
// import 'package:eventmatch/settings/provider/location.dart';
import 'package:agro_xplore/login/cubit/auth_cubit.dart';
import 'package:agro_xplore/login/widgets/glassmorphic_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../login/widgets/glassmorphic_box.dart';
import '../../profile/cubit/my_user_cubit.dart';

class FormSignUp extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const FormSignUp();
  }

  const FormSignUp({super.key});
  @override
  State<FormSignUp> createState() => _FormSignUpState();
}

class _FormSignUpState extends State<FormSignUp> {
  // File? imageGallery;
  final formKey = GlobalKey<FormState>();
  // String? name;
  final _nameController = TextEditingController();
  bool isSaving = false;
  // final picker = ImagePicker();

  void _mostrarTerminosCondiciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Términos y Condiciones"),
          content: const SingleChildScrollView(
            child: Text(
                "Por favor lee detenidamente estos Términos y Condiciones ....",
                textAlign: TextAlign.justify),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                  child: const Text("Aceptar"),
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<MyUserCubit>();
                    setState(() {
                      isSaving = true;
                    });
                    await context.read<MyUserCubit>().saveMyuser(
                          // ignore: use_build_context_synchronously
                          (context.read<AuthCubit>().state as AuthSignedIn)
                              .user
                              .uid,
                          _nameController.text,
                          // await getGeoHash(),
                        );
                  }),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text("Regístrate",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(12.0),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: GlassBox(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _nameController,
                          maxLength: 20,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'obligatorio';
                            }
                            if (value.length < 2 || value.length > 20) {
                              return 'El nombre debe tener entre 2 y 20 caracteres';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Tu nombre',
                              labelStyle: TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: GlassBox(
                          onTap: isSaving
                              ? null
                              : () {
                                  if (formKey.currentState!.validate() &&
                                      !isSaving) {
                                    _mostrarTerminosCondiciones(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoAlertDialog(
                                        title: const Text(
                                            'Faltan rellenar algunos campos'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                          color: (!isSaving && _nameController.text.isNotEmpty)
                              ? Colors.green
                              : Colors.grey,
                          child: const Text('Guardar',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      if (isSaving)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  const Tag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}
