// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:ezzem/components/order_management_components/Checkout.dart';
import 'package:ezzem/components/custome_components/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _selectedCountry = 'Select Country';
  String _userId = "";
  double totalPrice = 0.0;
  Map<DocumentSnapshot, bool> itemSelection = {};
  late StreamController<void> _quantityChangeController;
  late StreamSubscription<void> _quantityChangeSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _quantityChangeController = StreamController<void>();
    _quantityChangeSubscription = _quantityChangeController.stream.listen((_) {
      updateTotalPrice(() {});
    });
  }

  @override
  void dispose() {
    _quantityChangeController.close();
    _quantityChangeSubscription.cancel();
    super.dispose();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  void toggleSelection(DocumentSnapshot doc, bool isSelected) {
    setState(() {
      itemSelection[doc] = isSelected;
    });
  }

  void updateTotalPrice(void Function() onQuantityChanged) {
    totalPrice = 0.0;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        var product = doc.data();
        totalPrice += product['quantity'] * product['price'];
      });
      onQuantityChanged();
    }).catchError((error) {
      print('Error retrieving cart items: $error');
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedItems();
                Navigator.of(context).pop();
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedItems() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .get();

    for (var doc in snapshot.docs) {
      if (itemSelection[doc] == true) {
        await doc.reference.delete();
      }
    }

    updateTotalPrice(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_userId)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('Cart is empty');
                        }
                        int totalItems = snapshot.data!.docs.length;
                        return Text(
                          'Cart ($totalItems items)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: itemSelection.isNotEmpty
                            ? _showDeleteConfirmationDialog
                            : null,
                      ),
                      ClickableIconButton(
                        onPressed: () {
                          print("Notification button Clicked!");
                        },
                        icon: Icons.notifications,
                      ),
                      SizedBox(width: 12.0),
                      Icon(Icons.location_on),
                      SizedBox(width: 4),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedCountry,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Select Country',
                              child: Text('Where To'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'USA',
                              child: Text('USA'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Canada',
                              child: Text('Canada'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value!;
                            });
                          },
                          hint: Text('To ($_selectedCountry)'),
                          isExpanded: true,
                          underline: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .collection('cart')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return Text('No data found!');
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...documents.map((doc) {
                        Map<String, dynamic> product =
                            doc.data() as Map<String, dynamic>;
                        bool isSelected = itemSelection[doc] ?? false;
                        return CartItem(
                          product: product,
                          documentSnapshot: doc,
                          onQuantityChanged: updateTotalPrice,
                          onItemAddedToCart: updateTotalPrice,
                        );
                      }).toList(),
                      SizedBox(height: 16.0),
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDemoPage(),
                            ),
                          );
                        },
                        child: Text('Proceed to Checkout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF82249),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final Map<String, dynamic> product;
  final DocumentSnapshot documentSnapshot;
  final Function(void Function()) onQuantityChanged;
  final Function(void Function()) onItemAddedToCart;

  CartItem({
    required this.product,
    required this.documentSnapshot,
    required this.onQuantityChanged,
    required this.onItemAddedToCart,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late ValueNotifier<int> quantity;

  @override
  void initState() {
    super.initState();
    quantity = ValueNotifier<int>(widget.product['quantity']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _removeFromCart(widget.documentSnapshot);
              },
            ),
            Flexible(
              child: Container(
                width: 100,
                height: 200,
                child: Image.network(
                  widget.product['imageUrl'],
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product['name']),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Color: ${widget.product['color']} | Size: ${widget.product['size']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.product['price']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity.value > 0) {
                            quantity.value--;
                            widget.product['quantity'] = quantity.value;
                            widget.onQuantityChanged(() {});
                          }
                        });
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: quantity,
                      builder: (context, value, child) {
                        return Text(value.toString());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity.value++;
                          widget.product['quantity'] = quantity.value;
                          widget.onQuantityChanged(() {});
                          widget.onItemAddedToCart(() {});
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  void _removeFromCart(DocumentSnapshot itemSnapshot) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(itemSnapshot.id)
          .delete();
      widget.onQuantityChanged(() {});
    } catch (error) {
      print('Error removing item from cart: $error');
    }
  }
}
