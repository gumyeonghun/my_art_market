import 'package:flutter/material.dart';
import 'package:my_art_market/pages/cart_page.dart';

class HomePageAppbar extends StatelessWidget {
  const HomePageAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined,color: Colors.white,size: 30,),
        SizedBox(width: 10,),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
