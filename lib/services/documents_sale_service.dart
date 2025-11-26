import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentsSaleService {
  final CollectionReference _documentsSales =
      FirebaseFirestore.instance.collection('documents_sales');

  // Add a new document sale
  Future<void> addSale({
    required String title,
    required String content,
    required String documentAddress,
    String? thumbnailUrl,
  }) async {
    await _documentsSales.add({
      'title': title,
      'content': content,
      'documentAddress': documentAddress,
      'thumbnailUrl': thumbnailUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'isSale': false,
    });
  }

  // Get stream of document sales
  Stream<QuerySnapshot> getSalesStream() {
    return _documentsSales.orderBy('createdAt', descending: true).snapshots();
  }

  // Update an existing document sale
  Future<void> updateSale({
    required String docId,
    required String title,
    required String content,
    required String documentAddress,
    String? thumbnailUrl,
  }) async {
    await _documentsSales.doc(docId).update({
      'title': title,
      'content': content,
      'documentAddress': documentAddress,
      'thumbnailUrl': thumbnailUrl ?? '',
    });
  }

  // Delete a document sale
  Future<void> deleteSale(String docId) async {
    await _documentsSales.doc(docId).delete();
  }
}
