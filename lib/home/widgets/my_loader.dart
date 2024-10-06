import 'package:flutter/material.dart';

class MyLoader extends StatefulWidget {
  const MyLoader({super.key});

  @override
  MyLoaderState createState() => MyLoaderState();
}

class MyLoaderState extends State<MyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duración de la rotación
    )..repeat(); // Repetir la animación infinitamente
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          child: Image.asset(
            'assets/icono_exterior.png', // Ruta de la imagen en tus activos
            width: 200,
            height: 200,
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _controller.value *
                  2.0 *
                  3.1415926535897932, // Ángulo en radianes (gira 360 grados)
              child: child,
            );
          },
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 18,
            child: Image.asset(
              'assets/icono_interior.png',
              width: 200,
              height: 200,
            )),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante: liberar recursos
    super.dispose();
  }
}
