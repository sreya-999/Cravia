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
      _items[index].quantity++;
      _quantities[productId] = _items[index].quantity;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
      _quantities[productId] = _items[index].quantity;
      notifyListeners();
    }
  }


  double getTotalAmount(List<ProductModel> products) {
    double total = 0;
    for (var product in products) {
      final qty = getQuantity(product.id);
      total += (product.price ?? 0.0) * qty;
    }
    return total;
  }

  // void removeItem(int productId) {
  //   _items.removeWhere((item) => item.id == productId);
  //   _quantities.remove(productId);
  //   notifyListeners();
  // }

  void removeItem(int productId, {String? childCategoryId}) {
    print("🗑 Trying to remove: productId=$productId, childCategoryId=$childCategoryId");

    _items.removeWhere((item) {
      print("🔎 Checking item -> id=${item.id} (${item.id.runtimeType}), "
          "child=${item.childCategoryId} (${item.childCategoryId.runtimeType})");

      final sameProduct = item.id.toString() == productId.toString();

      if (childCategoryId == null) {
        final match = sameProduct && (item.childCategoryId == null || item.childCategoryId!.isEmpty);
        if (match) print("✅ Match found -> removing item without childCategoryId");
        return match;
      } else {
        final match = sameProduct && item.childCategoryId?.trim() == childCategoryId.trim();
        if (match) print("✅ Match found -> removing item with childCategoryId");
        return match;
      }
    });

    // Use combined key
    final key = childCategoryId == null
        ? productId.toString()
        : '$productId-${childCategoryId.trim()}';

    print("🗑 Removing from quantities with key: $key");
    _quantities.remove(key);

    notifyListeners();
  }





  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  // void addToCart(CartItemModel newItem) {
  //   final index = _items.indexWhere((item) => item.id == newItem.id);
  //
  //   if (index != -1) {
  //     // Replace with the new quantity instead of adding
  //     _items[index] = newItem;
  //   } else {
  //     _items.add(newItem);
  //   }
  //   notifyListeners();
  // }

  void addToCart(CartItemModel newItem) {
    // 1️⃣ Find index of an item with the same id AND same childCategoryId
    final index = _items.indexWhere(
          (item) => item.id == newItem.id && item.childCategoryId == newItem.childCategoryId,
    );

    if (index != -1) {
      // 2️⃣ If the item exists with the same id & category, replace it
      _items[index] = newItem;
    } else {
      // 3️⃣ If it's a completely new combination, add it as a new item
      _items.add(newItem);
    }

    // 4️⃣ Notify listeners so the UI rebuilds
    notifyListeners();
  }

  // void addToCart(CartItemModel item) {
  //   final existingIndex = _items.indexWhere(
  //         (e) => e.id == item.id && e.childCategoryId == item.childCategoryId,
  //   );
  //
  //   if (existingIndex != -1) {
  //     // If item already exists, just increase quantity
  //     _items[existingIndex].quantity += item.quantity;
  //     _quantities[item.id] = _items[existingIndex].quantity;
  //   } else {
  //     // Add new item
  //     _items.add(item);
  //     _quantities[item.id] = item.quantity;
  //   }
  //
  //   notifyListeners();
  // }


  double get subTotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get subTotalss {
    double total = 0;
    for (var item in _items) {
      // Add the total price of the item
      total += (item.price * item.quantity);

      // Safely subtract the takeaway price (use 0.0 if null)
      total -= (item.takeAwayPrice ?? 0.0);
    }
    return total < 0 ? 0 : total; // Prevent negative totals
  }



  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  String formatTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      return "$hours hr ${minutes.toString().padLeft(2, '0')} mins";
    } else {
      return "$minutes mins";
    }
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


  int get totalEstimatedTime {
    int totalTime = 0;

    for (var item in _items) {
      if (item.prepareTime != null) {
        // Clean up delivery time string like "30 mins"
        final baseTime = int.tryParse(
          item.prepareTime.toString().toLowerCase().replaceAll("mins", "").trim(),
        ) ?? 0;
        print("Item: ${item.name}, Prepare Time: $baseTime mins, Quantity: ${item.quantity}");
        totalTime += baseTime * item.quantity;
      }
    }
    return totalTime;
  }

  double get totalPackingCharge {
    double totalCharge = 0;
    for (var item in _items) {
      // Use the takeAwayPrice if available
      final double? charge = item.takeAwayPrice;
      if (charge != null) totalCharge += charge * item.quantity;
    }
    return totalCharge;
  }

}
