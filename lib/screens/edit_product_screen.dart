import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/product.dart';
import 'package:providerapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String productID;
  String newID, newTitle, newDescription, newImageURL;
  double price;

  Product _editedProduct = new Product.emptyProduct(id: null);

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageURL
        };
        _imageURLController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();

    super.dispose();
  }

  void _saveForm() {
    var newID =
        Provider.of<ProductsProvider>(context, listen: false).items.length + 1;
    if (_form.currentState.validate()) {
      _form.currentState.save();
      if (_editedProduct.id == null) {
        var newProduct = new Product(
            id: newID.toString(),
            title: newTitle,
            description: newDescription,
            imageURL: newImageURL,
            price: price);
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(newProduct);
      } else {
        var newProduct = new Product(
            id: _editedProduct.id,
            title: newTitle,
            description: newDescription,
            imageURL: newImageURL,
            isFavourite: _editedProduct.isFavourite,
            price: price);
        Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, newProduct);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                    onSaved: (value) {
                      newTitle = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: _initValues['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        price = double.parse(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a price";
                        } else if (double.tryParse(value) == null) {
                          return "Please enter a valid number";
                        } else if (double.parse(value) <= 0) {
                          return "Please enter a number greater than 0";
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        newDescription = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a description";
                        } else if (value.length < 10) {
                          return "Please enter a description longer than 10 characters";
                        }
                        return null;
                      }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        margin: EdgeInsets.only(top: 8, right: 10),
                        child: Container(
                            child: _imageURLController.text.isEmpty
                                ? Center(child: Text('Enter a URL'))
                                : FittedBox(
                                    child:
                                        Image.network(_imageURLController.text),
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _imageURLController,
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            newImageURL = value;
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
    ;
  }
}
