import 'package:cloud_firestore/cloud_firestore.dart';

class ImageSaleService {
  final CollectionReference _imageSales =
      FirebaseFirestore.instance.collection('image_sales');

  // Add a new image sale
  Future<void> addSale({
    required String title,
    required String content,
    required String imageAddress,
  }) async {
    await _imageSales.add({
      'title': title,
      'content': content,
      'imageAddress': imageAddress,
      'createdAt': FieldValue.serverTimestamp(),
      'isSale': false, // Default value as per current logic
    });
  }

  // Get stream of image sales
  Stream<QuerySnapshot> getSalesStream() {
    return _imageSales.orderBy('createdAt', descending: true).snapshots();
  }

  // Update an existing image sale
  Future<void> updateSale({
    required String docId,
    required String title,
    required String content,
    required String imageAddress,
  }) async {
    await _imageSales.doc(docId).update({
      'title': title,
      'content': content,
      'imageAddress': imageAddress,
    });
  }

  // Delete an image sale
  Future<void> deleteSale(String docId) async {
    await _imageSales.doc(docId).delete();
  }
}
