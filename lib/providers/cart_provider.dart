import 'package:flutter/material.dart';

import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> _quantities = {}; // productId -> quantity

  int getQuantity(int productId) {
    return _quantities[productId] ?? 0;
  }
  int get totalItems => _quantities.values.fold(0, (sum, qty) => sum + qty);

  void increment(int productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _items[index].quantity += 1;  // update quantity directly
    } else {

    }
    notifyListeners();
  }

  void decrement(int productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity -= 1;
      notifyListeners();
    }
  }


  double getTotalAmount(List<ProductModel> products) {
    double total = 0;
    for (var product in products) {
      final qty = getQuantity(product.id);
      total += (product.price! * qty)!;
    }
    return total;
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.id == productId); // remove from cart list
    _quantities.remove(productId); // also remove from quantities map
    notifyListeners();
  }


  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addToCart(CartItemModel item) {
    // Look for same product *with same subcategory*
    final existingIndex = _items.indexWhere(
          (e) => e.id == item.id && e.childCategoryId == item.childCategoryId,
    );

    if (existingIndex != -1) {
      // If exact product+subcategory already exists → increase quantity
      _items[existingIndex].quantity += item.quantity;
    } else {
      // Otherwise → add as a new line item
      _items.add(item);
    }

    notifyListeners();
  }



  double get subTotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  CartItemModel? getCartItemById(int productId, {String? childCategoryId}) {
    try {
      return _items.firstWhere(
            (item) => item.id == productId && item.childCategoryId == childCategoryId,
      );
    } catch (e) {
      return null;
    }
  }


  String? _selectedTable;

  String? get selectedTable => _selectedTable;

  void selectTable(String tableName) {
    _selectedTable = tableName;
    notifyListeners();
  }

  void clearSelection() {
    _selectedTable = null;
    notifyListeners();
  }

  double get subTotals {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double packingCharge = 10;

  double get total {
    return subTotals;
  }
}
