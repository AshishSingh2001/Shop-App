import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

    try {
      await http.post(
        url,
        body: json.encode(
          {},
        ),
      );
    } catch (e) {}
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
