import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                  ),
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProducts(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (_, index) {
              return Column(
                children: [
                  UserProductItem(
                    id: productsData.items[index].id,
                    title: productsData.items[index].title,
                    imageUrl: productsData.items[index].imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
            itemCount: productsData.items.length,
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
