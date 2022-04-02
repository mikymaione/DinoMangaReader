import 'package:dino_manga_reader/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dino Manga Reader',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
