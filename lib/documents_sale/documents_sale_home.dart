import 'package:flutter/material.dart';
import 'package:my_art_market/home_page_appbar.dart';

class DocumentsSaleHome extends StatelessWidget {
  const DocumentsSaleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.yellow,
      width: 130,
        child: Text('작성글',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      );
  }
}
