import 'package:flutter/material.dart';
import 'package:my_art_market/image_sale/image_sale_home.dart';
import 'package:my_art_market/sale/sale.dart';


class ImageSaleWrite extends StatefulWidget {
  const ImageSaleWrite({super.key});

  @override
  State<ImageSaleWrite> createState() => _ImageSaleWriteState();
}

class _ImageSaleWriteState extends State<ImageSaleWrite> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  final TextEditingController imageAddressController = TextEditingController();

  List<Sale> saleList = [];

  void onCreate (){

    setState(() {
      Sale newSale = Sale(title: titleController.text,
          imageAddress: imageAddressController.text,
          content: contentController.text,
          isSale: false);
      saleList.add(newSale);
      titleController.clear();
      imageAddressController.clear();
      contentController.clear();
    }
    );
  }

  @override
  void dispose(){
    super.dispose();
    titleController.dispose();
    imageAddressController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('IMAGE',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
          child: ListView(
            children: [
              Container(
                width: 200,
                height: 70,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ImageSaleHome(
                          saleList: saleList
                        ,
                        );
                      }
                      )
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: Text('이미지 판매목록 바로가기',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ),
              ),
              SizedBox(height: 20,),
              Divider(height: 10,),
              SizedBox(height: 20,),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, width: 5
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(Icons.image,size: 100,color: Colors.lightBlue,),
                  ),
                  SizedBox(height: 30,),
                  Text('이미지를 업로드 해주세요',style: TextStyle(fontSize: 20),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '제목',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: 1,
                    controller: imageAddressController,
                    decoration: InputDecoration(
                      hintText: '이미지 파일 주소',
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  height: 150,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLines: null,
                    controller: contentController
                    ,
                    decoration: InputDecoration(
                      hintText: '내용',
                    ),
                  ),
                ),
                  ]
                ),
              ),
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      onCreate();

                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return ImageSaleHome(
                            saleList: saleList,
                          );
                        }
                        )
                        );
                      },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                        ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: Text('판매등록',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
