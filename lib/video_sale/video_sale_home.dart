import 'package:flutter/material.dart';

class VideoSaleHome extends StatelessWidget {
  const VideoSaleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.yellow,
        width: 130,
        child: Text('동영상',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      );
  }
}
