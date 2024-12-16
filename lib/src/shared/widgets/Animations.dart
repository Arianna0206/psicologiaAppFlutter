import 'package:flutter/material.dart';

Route fade(Widget pagina) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pagina,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1000),
  );
}