import 'package:flutter/material.dart';
import 'package:my_art_market/image_sale/image_sale_detail.dart';

class ImageSaleIndex extends StatefulWidget {
  const ImageSaleIndex({
    required this.docId,
    required this.title,
    required this.imageAddress,
    required this.content,
    required this.isSale,
    super.key,
  });

  final String docId;
  final String title;
  final String imageAddress;
  final String content;
  final bool isSale;

  @override
  State<ImageSaleIndex> createState() => _ImageSaleIndexState();
}

class _ImageSaleIndexState extends State<ImageSaleIndex> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.imageAddress);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ImageSaleDetail(
            docId: widget.docId,
            title: widget.title,
            imageAddress: widget.imageAddress,
            content: widget.content,
          );
        }));
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[500],
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                      child: AspectRatio(
                          aspectRatio: 1/0.9,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                              child: Image.network(widget.imageAddress.toString(),fit: BoxFit.cover,)))),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 50,
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("이미지 제목",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                  Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),),
                  SizedBox(width: 10,)
                ],
              ),
            ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
