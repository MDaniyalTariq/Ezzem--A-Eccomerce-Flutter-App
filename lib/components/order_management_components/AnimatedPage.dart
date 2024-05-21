import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnimatedPage extends StatelessWidget {
  final String orderType;
  final double mWidth;
  final double mHeight;

  AnimatedPage({
    required this.orderType,
    required this.mWidth,
    required this.mHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Divider(
              color: Colors.black,
              thickness: 8.0,
              height: 20.0,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: mWidth,
            height: mHeight * 0.75,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF82249),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      orderType,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: _fetchProductDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFF82249),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        var products = snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            filteredProducts = [];
                        for (var product in products) {
                          var status = product.data()['status'];
                          if (status is List && status.contains(orderType)) {
                            filteredProducts.add(product);
                          } else if (status is String && status == orderType) {
                            filteredProducts.add(product);
                          }
                        }

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Text(
                              'No products available for $orderType',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            var productData = filteredProducts[index].data();
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  productData['imageUrl'] ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['name'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price: \$${productData['price'] ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Quantity: ${productData['quantity'] ?? ''}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: null,
                                icon: Icon(Icons.arrow_forward),
                              ),
                              onTap: () {},
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchProductDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference orderCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('order_tracking');

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await orderCollection.get() as QuerySnapshot<Map<String, dynamic>>;

    return querySnapshot;
  }
}
