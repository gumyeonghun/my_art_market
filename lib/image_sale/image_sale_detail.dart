import 'package:flutter/material.dart';
import 'package:my_art_market/home_page_appbar.dart';

class ImageSaleDetail extends StatelessWidget {
  const ImageSaleDetail({required this.imageAddress, required this.content, super.key});

  final String imageAddress;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);
        }, icon: Icon(Icons.exit_to_app,color: Colors.white,),
        ),
        backgroundColor: Colors.orange,
        title: Text('IMAGE', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize:25)),
        centerTitle: true,
        actions: [
          HomePageAppbar(),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                    child: AspectRatio(
                    aspectRatio: 1.5/1,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(imageAddress.toString(),fit: BoxFit.cover,)))),
                SizedBox(height: 10,),
                Text('이미지 파일주소',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[300],
                  ),
                  alignment: Alignment.center,
                  child: Text(imageAddress,
                    style: TextStyle(fontSize: 15, color: Colors.blue,fontWeight: FontWeight.bold),
                  ),
                  width: double.infinity,
                  height: 120,
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(content,
                    style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  width: double.infinity,
                  height: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
