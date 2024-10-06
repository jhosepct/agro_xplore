import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double opacity2;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  const GlassBox({
    super.key,
    required this.child,
    this.onTap,
    this.color = Colors.white60,
    this.opacity2 = 0.1,
    this.padding = const EdgeInsets.all(8),
    this.border = const Border(
      top: BorderSide(width: 1, color: Colors.white30),
      bottom: BorderSide(width: 1, color: Colors.white30),
      left: BorderSide(width: 1, color: Colors.white30),
      right: BorderSide(width: 1, color: Colors.white30),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(25);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: border,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [color, color.withOpacity(opacity2)],
              ),
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
