import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/products_provider.dart';
import 'package:providerapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem(this.id, this.title, this.imageUrl);

  final String id, title, imageUrl;
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
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
