import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  var startup = true;

  ProductsProvider() {
//    getProductsFromService();
  }

  List<Product> _items = [];
  /*List<Product> _items = [
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
  ];*/

  final service = FireStoreService();

  var _showFavourites = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  List<Product> userFavouriteItems(List<String> favItems) {
    return _items.where((product) => favItems.contains(product.id)).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void deleteProduct(String productID) {
    _items.removeWhere((element) => element.id == productID);
    deleteFromFireStore(productID);
    notifyListeners();
  }

  void deleteFromFireStore(String id) async {
    await _db.collection("products").document(id).delete().then((_) {
      print("Item Deleted");
    });
  }

  void updateProduct(String id, Product newProduct) async {
    var prod = _items.indexWhere((item) => item.id == id);
    if (prod != null) {
      _items[prod] = newProduct;
      saveData(newProduct);
    }
    notifyListeners();
  }

  void saveData(Product newProduct) async {
    try {
      await _db
          .collection("products")
          .document(newProduct.id)
          .setData(newProduct.createMap(), merge: true)
          .then((_) {
        print("success saving data");
      });
    } on PlatformException catch (e) {
      print("${e.toString()}");
    }
  }

  void refreshProductsListFromService() {
    startup = true;
    _items.clear();
    getProductsFromService();
  }

  void getProductsFromService() async {
//    List<Product> temp
    if (startup) {
      await _db
          .collection('products')
          .getDocuments()
          .then((snapShot) => {
                snapShot.documents.forEach((result) {
//            _fireItems.add(new Product.fromFirestore(result));
                  _items.add(Product.fromFirestore(result));
                })
              })
          .whenComplete(() => {notifyListeners()});
      startup = false;
    }
    print("${_items.length} is the length of the FIREITEMS");
    if (_items.isNotEmpty) {
      _items.forEach((element) {
        print(
            "§§§§§§§ ${element.id} ${element.title} ${element.price} ${element.isFavourite} §§§§§§§");
      });
    }
  }
//
//  Stream<List<Product>> getProductsFromServiceStream() {
//    return _db.collection('products').snapshots().map((snapshot) => snapshot
//        .documents
//        .map((document) => Product.fromFirestore(document.data))
//        .toList());
//  }

  void saveDataFromService(List<Product> newProducts) {
    items.addAll(newProducts);
  }

  void addProduct(Product newProduct) {
    _items.add(newProduct);
    saveData(newProduct);
    notifyListeners();
  }
}

class FireStoreService {
  Firestore _db = Firestore.instance;

  Future<void> saveProduct(Product product) {
    return _db
        .collection('products')
        .document(product.id)
        .setData(product.createMap());
  }

  Future<void> saveProducts(List<Product> products) async {
    for (Product product in products) {
      this.saveProduct(product);
    }
  }
//
//  Stream<List<Product>> getProducts(BuildContext context) {
//    var temp = _db.collection('Products').snapshots().map((snapshot) => snapshot
//        .documents
//        .map((document) => Product.fromFirestore(document.data))
//        .toList());
////    var productsProvider =
////    Provider.of<ProductsProvider>(context, listen: false);
////    productsProvider.setDataFromService(temp);
//    return temp;
//  }

  Future<void> removeItem(String productId) {
    return _db.collection('Products').document(productId).delete();
  }
}
