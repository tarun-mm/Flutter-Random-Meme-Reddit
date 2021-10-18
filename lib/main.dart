import 'package:flutter/material.dart';
import 'package:meme_app/pages/loading.dart';
import 'package:meme_app/pages/home.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const Home(),
    },
  ),
);