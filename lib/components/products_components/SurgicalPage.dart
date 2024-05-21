import 'package:flutter/material.dart';
import 'package:ezzem/components/products_components/ProductCatelogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurgicalPage extends StatefulWidget {
  @override
  _SurgicalPageState createState() => _SurgicalPageState();
}

class _SurgicalPageState extends State<SurgicalPage> {
  final List<String> surgicalCategories = [
    'All',
    'Category 1',
    'Category 2',
    'Category 3'
  ];

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surgical Instruments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('surgicals').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final List<Product> surgicalProducts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              imagePath: data['imagePath'],
              name: data['name'],
              code: data['code'],
              category: data['category'],
              description: data['description'],
            );
          }).toList();

          return ProductCatalog(
            categories: surgicalCategories,
            itemBuilder: (BuildContext context, String category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Surgical Instruments'),
                    subtitle: Text('Category: $category'),
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: surgicalProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Product product = surgicalProducts[index];
                        if (selectedCategory == 'All' ||
                            product.category == selectedCategory) {
                          return GridTile(
                            child: Container(
                              color: Colors.grey[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    product.imagePath,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 8),
                                  Text(product.name),
                                  Text(product.code),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            products: surgicalProducts,
          );
        },
      ),
    );
  }
}
