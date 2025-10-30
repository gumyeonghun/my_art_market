import 'package:flutter/material.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/image_sale/image_sale_index.dart';
import 'package:my_art_market/image_sale/image_sale_write.dart';
import 'package:my_art_market/sale/sale.dart';

class ImageSaleHome extends StatelessWidget {
  const ImageSaleHome({required this.saleList,super.key});

 final List<Sale> saleList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.exit_to_app,color: Colors.white,),
        ),
        backgroundColor: Colors.orange,
        title: Text('IMAGE', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize:25)),
        centerTitle: true,
        actions: [
          HomePageAppbar(),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        itemCount: saleList.length,
        separatorBuilder: (context, index){
          return SizedBox(height: 30,);
        },
        itemBuilder: (context, index){
          Sale sale = saleList[index];
          return ImageSaleIndex(
            title: sale.title,
            imageAddress: sale.imageAddress,
            content: sale.content
            ,isSale: sale.isSale
            ,
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
