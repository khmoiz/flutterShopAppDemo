import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/carts_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id, title, productId;
  final double price;
  final int quantity;

  CartItemWidget(
      this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Are you sure ?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<CartsProvider>(context, listen: false)
            .removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('\$${price}'),
              )),
            ),
            title: Text('$title'),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x items'),
          ),
        ),
      ),
    );
  }
}
