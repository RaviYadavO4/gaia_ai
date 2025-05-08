import 'package:flutter/material.dart';

void pushWithFade(BuildContext context, Widget screen) {
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
  ));
}

void pushReplacementWithFade(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
  ));
}
