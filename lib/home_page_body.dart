import 'package:flutter/material.dart';
import 'package:my_art_market/documents_sale/documents_sale_home.dart';
import 'package:my_art_market/home_page_bottom_advertise.dart';
import 'package:my_art_market/image_sale/image_sale_home.dart';
import 'package:my_art_market/image_sale/image_sale_write.dart';
import 'package:my_art_market/sale/sale.dart';
import 'package:my_art_market/video_sale/video_sale_home.dart';



class HomePageBody extends StatefulWidget {
  HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ImageSaleHome();
                  }
                  )
                  );
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image,size: 50, color: Colors.blue,),
                        SizedBox(height: 10,),
                        Text('이미지 사용권 판매',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap:(){
                  Navigator.push(context,MaterialPageRoute(builder:
                      (context){
                    return VideoSaleHome(
                    );
                  }
                  )
                  );
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.redAccent, width: 5),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.play_arrow_rounded,size: 50, color: Colors.red,)),
                        SizedBox(height: 10,),
                        Text('동영상 사용권 판매',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return DocumentsSaleHome(
                    );
                  }
                  )
                  );
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wordpress,size: 50, color: Colors.lightBlueAccent,),
                        SizedBox(height: 10,),
                        Text('작성글 사용권 판매',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        HomePageBottomAdvertise(),
      ],
    );
  }
}
