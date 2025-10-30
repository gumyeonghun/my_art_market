import 'package:flutter/material.dart';
import 'package:my_art_market/home_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY ART MARKET',
      home: HomePageView(),
    );
  }
}

