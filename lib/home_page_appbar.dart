import 'package:flutter/material.dart';

class HomePageAppbar extends StatelessWidget {
  const HomePageAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined,color: Colors.white,size: 30,),
        SizedBox(width: 10,),
        Icon(Icons.shopping_cart_outlined,color: Colors.white,size: 30,),
        SizedBox(width: 20),
      ],
    );
  }
}
