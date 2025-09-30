import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'category_provider.dart';
import 'package:provider/provider.dart';
class CartProvider with ChangeNotifier {
  //final Map<int, int> _quantities = {}; // productId -> quantity
  Map<String, int> _quantities = {};

  int getQuantity(int productId) {
    return _quantities[productId.toString()] ?? 0;
  }
  int get totalItems => _quantities.values.fold(0, (sum, qty) => sum + qty);


  // void increment(int productId) {
  //   final index = _items.indexWhere((item) => item.id == productId);
  //   if (index != -1) {
  //     _items[index].quantity++;
  //     _quantities[productId] = _items[index].quantity;
  //     notifyListeners();
  //   }
  // }
  //
  // void decrement(int productId) {
  //   final index = _items.indexWhere((item) => item.id == productId);
  //   if (index != -1 && _items[index].quantity > 1) {
  //     _items[index].quantity--;
  //     _quantities[productId] = _items[index].quantity;
  //     notifyListeners();
  //   }
  // }

  void increment(int productId, {String? childCategoryId}) {
    print('increment called for productId: $productId, childCategoryId: $childCategoryId');

    // If childCategoryId is not passed, find the first matching product
    final index = _items.indexWhere(
          (item) =>
      item.id == productId &&
          (childCategoryId == null || item.childCategoryId == childCategoryId),
    );

    if (index != -1) {
      _items[index].quantity++;
      _quantities[_getUniqueKey(_items[index].id, _items[index].childCategoryId)] =
          _items[index].quantity;
      notifyListeners();
    } else {
      print("No matching product found for productId: $productId");
    }
  }

  void decrement(int productId, {String? childCategoryId}) {
    print('decrement called for productId: $productId, childCategoryId: $childCategoryId');

    final index = _items.indexWhere(
          (item) =>
      item.id == productId &&
          (childCategoryId == null || item.childCategoryId == childCategoryId),
    );

    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
      _quantities[_getUniqueKey(_items[index].id, _items[index].childCategoryId)] =
          _items[index].quantity;
      notifyListeners();
    } else {
      print("No matching product found or quantity is already 1 for productId: $productId");
    }
  }

// Update _getUniqueKey to accept String? now
  String _getUniqueKey(int productId, String? childCategoryId) {
    return '$productId-${childCategoryId ?? 'none'}';
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

  void removeItem(BuildContext context, int productId, {String? childCategoryId}) {
    print("🗑 Trying to remove: productId=$productId, childCategoryId=$childCategoryId");

    _items.removeWhere((item) {
      print("🔎 Checking item -> id=${item.id}, child=${item.childCategoryId}");

      final sameProduct = item.id.toString() == productId.toString();

      if (childCategoryId == null) {
        final match = sameProduct && (item.childCategoryId == null || item.childCategoryId!.isEmpty);
        if (match) print("✅ Match found -> removing item without childCategoryId");
        return match;
      } else {
        final match = sameProduct && item.childCategoryId?.trim() == childCategoryId?.trim();
        if (match) print("✅ Match found -> removing item with childCategoryId");
        return match;
      }
    });

    final key = childCategoryId == null
        ? productId.toString()
        : '$productId-${childCategoryId?.trim()}';
    print("🗑 Removing from quantities with key: $key");
    _quantities.remove(key);

    // ✅ Reset category and quantity in CategoryProvider
    final categoryProvider = context.read<CategoryProvider>();
    categoryProvider.setSelectedChildCategorys(null, productId: productId);
    categoryProvider.resetLastSelectedChildCategory(productId);
    categoryProvider.setQuantity(1);
    print("🔄 Reset category & quantity for productId=$productId");

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
  void addToCart(BuildContext context, CartItemModel newItem) {
    // Find existing item with same id & childCategoryId
    final index = _items.indexWhere(
          (item) => item.id == newItem.id && item.childCategoryId == newItem.childCategoryId,
    );

    if (index != -1 && _items[index].quantity == newItem.quantity) {
      // Product already added with same quantity
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product already added with same quantity!'),
          duration: const Duration(seconds: 2),
        ),
      );
      return; // Do NOT add or replace, do NOT close dialog
    }

    if (index != -1) {
      // Quantity is different, update the item
      _items[index] = newItem;
    } else {
      // New item, add to cart
      _items.add(newItem);
    }

    notifyListeners();
  }


  bool isDuplicate(CartItemModel newItem) {
    final index = _items.indexWhere(
          (item) => item.id == newItem.id && item.childCategoryId == newItem.childCategoryId,
    );
    return index != -1 && _items[index].quantity == newItem.quantity;
  }


  // void addToCart(CartItemModel newItem) { /// old cart
  //   // 1️⃣ Find index of an item with the same id AND same childCategoryId
  //   final index = _items.indexWhere(
  //         (item) => item.id == newItem.id && item.childCategoryId == newItem.childCategoryId,
  //   );
  //
  //   if (index != -1) {
  //     // 2️⃣ If the item exists with the same id & category, replace it
  //     _items[index] = newItem;
  //   } else {
  //     // 3️⃣ If it's a completely new combination, add it as a new item
  //     _items.add(newItem);
  //   }
  //
  //   // 4️⃣ Notify listeners so the UI rebuilds
  //   notifyListeners();
  // }

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


  // int get totalEstimatedTime {
  //   int totalTime = 0;
  //
  //   for (var item in _items) {
  //     if (item.prepareTime != null) {
  //       // Clean up delivery time string like "30 mins"
  //       final baseTime = int.tryParse(
  //         item.prepareTime.toString().toLowerCase().replaceAll("mins", "").trim(),
  //       ) ?? 0;
  //       print("Item: ${item.name}, Prepare Time: $baseTime mins, Quantity: ${item.quantity}");
  //       totalTime += baseTime * item.quantity;
  //     }
  //   }
  //   return totalTime;
  // }

  double get averageEstimatedTime {
    int totalTime = 0;
    int totalQuantity = 0;

    for (var item in _items) {
      if (item.prepareTime != null) {
        // Clean up delivery time string like "30 mins"
        final baseTime = int.tryParse(
          item.prepareTime.toString().toLowerCase().replaceAll("mins", "").trim(),
        ) ?? 0;

        print("Item: ${item.name}, Prepare Time: $baseTime mins, Quantity: ${item.quantity}");

        totalTime += baseTime * item.quantity;
        totalQuantity += item.quantity;
      }
    }

    if (totalQuantity == 0) return 0; // avoid division by zero
    return totalTime / totalQuantity;
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
