import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int price; // price in KRW
  final String type; // e.g., 'image', 'video', 'document'
  final String? imageUrl; // URL for image or thumbnail

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  int get itemCount => _items.length;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
