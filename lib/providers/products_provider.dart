import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: '0',
        title: 'Red Item',
        description: 'Red Converse Sneaker Shoes',
        price: 19.99,
        imageURL:
            'https://www.fashionkibatain.com/wp-content/uploads/2017/04/New-High-top-Lace-Canvas-Shoes-Female-Casual-Free-Shipping-Women-White-Black-Red-Blue-2015.jpg'),
    Product(
        id: '1',
        title: 'Blue Item',
        description: 'Blue Sports Short Sleeve UV Shirt',
        price: 29.99,
        imageURL:
            'https://contents.mediadecathlon.com/p1306726/k\$54cf0197dec2bcec9cbf56936b1e0bca/men-s-short-sleeve-uv-protection-surfing-water-t-shirt-blue.jpg?&f=800x800'),
    Product(
        id: '2',
        title: 'Green Item',
        description: 'Green Forest Packing Bag',
        price: 39.99,
        imageURL:
            'https://www.deserres.ca/media/catalog/product/cache/3/image/9df78eab33525d08d6e5fb8d27136e95/1/2/120000_1_F23510-664_1.jpg'),
    Product(
        id: '3',
        title: 'Purple Item',
        description: 'Vivo Y17 Purple Phone 4GB + 128 GB 5000 mAh Battery',
        price: 49.99,
        imageURL:
            'https://cf.shopee.com.my/file/5f5d6a6d2d949ad7b664934beb80baac'),
  ];

  var showFavouritesOnly = false;

  List<Product> get items {
    if (showFavouritesOnly) {
      return _items.where((product) => product.isFavourite).toList();
    }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct() {}
}
