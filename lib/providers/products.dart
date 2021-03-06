import 'package:flutter/widgets.dart';
import 'package:shop_app/models/http_exception.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken = '';
  String userId = '';

  void update({
    required String newAuth,
    required String newId,
  }) {
    // _items = prevItems;
    authToken = newAuth;
    userId = newId;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return [...items.where((element) => element.isFavorite).toList()];
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
      'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString',
    );
    final favUrl = Uri.parse(
      'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken',
    );

    try {
      var res = await http.get(url);
      final List<Product> loadedProducts = [];
      // print(jsonDecode(res.body));
      if (json.decode(res.body) != null) {
        final extractedData = json.decode(res.body) as Map<String, dynamic>;
        final favRes = await http.get(favUrl);
        final favData = jsonDecode(favRes.body);
        extractedData.forEach(
          (prodId, prodData) {
            loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favData == null ? false : favData[prodId] ?? false,
            ));
          },
        );
      }
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken',
    );
    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newPrdoduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newPrdoduct);
      notifyListeners();
    } catch (e) {
      // print(e);
      throw (e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.parse(
      'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken',
    );

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      final index = _items.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _items[index] = newProduct;
      }
      notifyListeners();
      // print(json.decode(res.body));
    } catch (e) {
      // print(e);
      throw (e);
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-update-e6815-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(
        existingProductIndex,
        existingProduct,
      );
      notifyListeners();
      throw HttpException('Could not delete message');
    } else {
      existingProduct = null;
    }
  }
}
