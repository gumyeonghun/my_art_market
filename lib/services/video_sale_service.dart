import 'package:cloud_firestore/cloud_firestore.dart';

class VideoSaleService {
  final CollectionReference _videoSales =
      FirebaseFirestore.instance.collection('video_sales');

  // Add a new video sale
  Future<void> addSale({
    required String title,
    required String content,
    required String videoAddress,
    String? thumbnailUrl,
  }) async {
    await _videoSales.add({
      'title': title,
      'content': content,
      'videoAddress': videoAddress,
      'thumbnailUrl': thumbnailUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'isSale': false,
    });
  }

  // Get stream of video sales
  Stream<QuerySnapshot> getSalesStream() {
    return _videoSales.orderBy('createdAt', descending: true).snapshots();
  }

  // Update an existing video sale
  Future<void> updateSale({
    required String docId,
    required String title,
    required String content,
    required String videoAddress,
    String? thumbnailUrl,
  }) async {
    await _videoSales.doc(docId).update({
      'title': title,
      'content': content,
      'videoAddress': videoAddress,
      'thumbnailUrl': thumbnailUrl ?? '',
    });
  }

  // Delete a video sale
  Future<void> deleteSale(String docId) async {
    await _videoSales.doc(docId).delete();
  }
}
