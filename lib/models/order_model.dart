class OrderModel {
  final int orderId;
  final String orderNo;
  final double amount;

  OrderModel({
    required this.orderId,
    required this.orderNo,
    required this.amount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      orderNo: json['order_no'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
