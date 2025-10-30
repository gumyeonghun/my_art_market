import 'package:flutter/material.dart';

class HomePageBottomAdvertise extends StatelessWidget {
  const HomePageBottomAdvertise({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 5/1,
        child: Container(
          child:Image.asset('assets/chorok.webp',fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
