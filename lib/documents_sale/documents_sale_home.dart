import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_art_market/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/documents_sale/documents_sale_index.dart';
import 'package:my_art_market/documents_sale/documents_sale_write.dart';
import 'package:my_art_market/services/documents_sale_service.dart';
import 'package:my_art_market/pages/payment_page.dart';

class DocumentsSaleHome extends StatelessWidget {
  const DocumentsSaleHome({super.key});

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
        backgroundColor: Colors.lightBlue,
        title: const Text('DOCUMENTS',
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
        stream: DocumentsSaleService().getSalesStream(),
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
                  DocumentsSaleIndex(
                    docId: doc.id,
                    title: saleData['title'] ?? '',
                    documentAddress: saleData['documentAddress'] ?? '',
                    content: saleData['content'] ?? '',
                    isSale: saleData['isSale'] ?? false,
                    thumbnailUrl: saleData['thumbnailUrl'],
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
                                      title: saleData['title'] ?? '문서',
                                      price: 1000,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
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
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.lightBlue),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(
                              CartItem(
                                id: doc.id,
                                title: saleData['title'] ?? '',
                                price: 1000,
                                type: 'document',
                                imageUrl: saleData['thumbnailUrl'],
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
            MaterialPageRoute(builder: (context) => const DocumentsSaleWrite()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
