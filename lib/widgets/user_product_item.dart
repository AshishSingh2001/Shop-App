import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                var confirmDelete = false;
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('do you want to remove the item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('YES'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('NO'),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if (value) {
                    Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  }
                });
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
