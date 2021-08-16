import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
      'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken',
    );

    try {
      final res = await http.put(
        url,
        body: json.encode(
            isFavorite,
        ),
      );
      if (res.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('Failed to favorite item.');
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Failed to favorite item.');
    }
  }
}
