import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
