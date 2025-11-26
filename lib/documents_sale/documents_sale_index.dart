import 'package:flutter/material.dart';
import 'package:my_art_market/documents_sale/documents_sale_detail.dart';

class DocumentsSaleIndex extends StatelessWidget {
  const DocumentsSaleIndex({
    required this.docId,
    required this.title,
    required this.documentAddress,
    required this.content,
    required this.isSale,
    this.thumbnailUrl,
    super.key,
  });

  final String docId;
  final String title;
  final String documentAddress;
  final String content;
  final bool isSale;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DocumentsSaleDetail(
            docId: docId,
            title: title,
            documentAddress: documentAddress,
            content: content,
            thumbnailUrl: thumbnailUrl,
          );
        }));
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[400], // Distinct color for Documents
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
                          aspectRatio: 1 / 0.9,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.black12,
                            ),
                            child: const Icon(
                              Icons.description,
                              size: 80,
                              color: Colors.white,
                            ),
                          ))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "문서 제목",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      )
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
