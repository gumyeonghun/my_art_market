import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_art_market/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/image_sale/image_sale_index.dart';
import 'package:my_art_market/image_sale/image_sale_write.dart';
import 'package:my_art_market/services/image_sale_service.dart';
import 'package:my_art_market/pages/payment_page.dart';

class ImageSaleHome extends StatelessWidget {
  const ImageSaleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        title: const Text('IMAGE',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        centerTitle: true,
        actions: [
          HomePageAppbar(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ImageSaleService().getSalesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            itemCount: data.size,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 30,
              );
            },
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              final saleData = doc.data() as Map<String, dynamic>;

              return Column(
                children: [
                  ImageSaleIndex(
                    docId: doc.id,
                    title: saleData['title'] ?? '',
                    imageAddress: saleData['imageAddress'] ?? '',
                    content: saleData['content'] ?? '',
                    isSale: saleData['isSale'] ?? false,
                  ),
                  const SizedBox(height: 10),
                  Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      title: saleData['title'] ?? '이미지',
                                      price: 1000,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('구매하기 (1,000원)'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(
                              CartItem(
                                id: doc.id,
                                title: saleData['title'] ?? '',
                                price: 1000,
                                type: 'image',
                                imageUrl: saleData['imageAddress'],
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('장바구니에 추가되었습니다')),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImageSaleWrite()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
