import 'package:flutter/material.dart';

class UserFavouriteProductItem extends StatelessWidget {
  final String id, title, imageUrl;

  UserFavouriteProductItem(this.id, this.title, this.imageUrl);

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
          children: <Widget>[],
        ),
      ),
    );
  }
}
