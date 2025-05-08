import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingSpinner() => Center(
  child: SpinKitFadingCircle(
    color: Colors.deepPurple,
    size: 50.0,
  ),
);
