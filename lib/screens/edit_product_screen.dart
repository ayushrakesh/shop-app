import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final imageUrlFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final form = GlobalKey<FormState>();
  var editedProduct = Product(
    title: '',
    id: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  var isInit = true;

  var isLoading = false;

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool light = true;

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  void updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        editedProduct = Provider.of<Products>(context, listen: false)
            .findProductBy(productId);

        initValues = {
          'id': '',
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
        };
        imageUrlController.text = editedProduct.imageUrl;
      }

      isInit = false;
    }
    super.didChangeDependencies();
  }

  void dispose() {
    imageUrlFocusNode.removeListener(updateImageUrl);
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveForm() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return;
    }

    form.currentState!.save();
    setState(() {
      isLoading = true;
    });

    // ignore: unnecessary_null_comparison
    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  'An error occured',
                ),
                content: Text(
                  error.toString(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'Okay',
                    ),
                  )
                ],
              );
            });
      } finally {
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        actions: [
          IconButton(
            onPressed: () {
              saveForm();
            },
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(
                16,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            isFavourite: editedProduct.isFavourite,
                            title: value!,
                            description: editedProduct.description,
                            imageUrl: editedProduct.description,
                            price: editedProduct.price,
                          );
                        },
                        validator: (value) {
                          if (!value!.isEmpty) {
                            return null;
                          } else {
                            return 'Please provide valid title';
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            isFavourite: editedProduct.isFavourite,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            imageUrl: editedProduct.description,
                            price: double.parse(
                              value!,
                            ),
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please provide a valid price';
                          } else if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            isFavourite: editedProduct.isFavourite,
                            title: editedProduct.title,
                            description: value!,
                            imageUrl: editedProduct.description,
                            price: editedProduct.price,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          } else if (value.length < 10) {
                            return 'Description must be at least 10 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 12,
                            ),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: imageUrlController.text.isEmpty
                                ? Text('Enter image URL')
                                : FittedBox(
                                    child: Image.network(
                                      imageUrlController.text,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              controller: imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              onSaved: (value) {
                                editedProduct = Product(
                                  id: editedProduct.id,
                                  isFavourite: editedProduct.isFavourite,
                                  title: editedProduct.title,
                                  description: editedProduct.description,
                                  imageUrl: value!,
                                  price: editedProduct.price,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an image url';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
