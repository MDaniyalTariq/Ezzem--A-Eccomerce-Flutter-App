import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzem/components/order_management_components/Cart.dart';
import 'package:ezzem/components/products_components/Product_Description_widget.dart';
import 'package:ezzem/components/order_management_components/Shop.dart';
import 'package:ezzem/components/custome_components/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Review {
  final String reviewerName;
  final double rating;
  final String time;
  final String message;
  final List<String> assetPaths;

  Review({
    required this.reviewerName,
    required this.rating,
    required this.time,
    required this.message,
    required this.assetPaths,
  });
}

List<Review> reviews = [
  Review(
    reviewerName: 'M.Daniyal Tariq',
    rating: 4.5,
    time: '2 hours ago',
    message: 'Great product! Highly recommended.',
    assetPaths: ['assests/image1.jpg', 'assests/image2.jpg'],
  ),
  Review(
    reviewerName: 'M.Suleman',
    rating: 5.0,
    time: '1 day ago',
    message: 'Excellent service and fast delivery.',
    assetPaths: ['assests/image1.jpg', 'assests/image2.jpg'],
  ),
  Review(
    reviewerName: 'M.Saqib Iqbal',
    rating: 5.0,
    time: '1 day ago',
    message: 'Excellent service and fast delivery.',
    assetPaths: ['assests/image1.jpg', 'assests/image2.jpg'],
  ),
];

class ReviewItem extends StatelessWidget {
  final Review review;

  ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${review.reviewerName} - ${review.rating} stars',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                review.time,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(review.message),
          SizedBox(height: 4),
          if (review.assetPaths.isNotEmpty)
            Row(
              children: review.assetPaths
                  .map((path) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          path,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isFavorite = false;
  double rating = 3.9;

  String selectedDeliveryOption = 'Standard';

  TextEditingController reviewController = TextEditingController();

  void addToWishlist(Product product) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      bool alreadyExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .where('name', isEqualTo: product.name)
          .get()
          .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

      if (!alreadyExists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .add({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imagePath,
          'category': product.category,
          'timestamp': DateTime.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to wishlist.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your wishlist.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  void addToHistory(Product product) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history')
          .add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imagePath,
        'category': product.category,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error adding to history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.product.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.product.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          if (isFavorite) {
                            addToWishlist(widget.product);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ProductDescriptionWidget(
                      description: widget.product.description),
                  SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 170,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFF82249),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _showAddToCartDialog(context, widget.product);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  color: Colors.grey[200],
                                  child: Text(
                                    'Return Policies',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Here i can display the return policies information.',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Return Policies'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text(
                              '$rating/5',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rating and Reviews',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF82249),
                                foregroundColor: Colors.white,
                              ),
                              child: Text('View All'),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('What people like about it:'),
                            SizedBox(width: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      CustomFilterChip(
                                        label: 'Good Prices',
                                        selected: false,
                                        onSelected: (selected) {},
                                      ),
                                      SizedBox(width: 8),
                                      CustomFilterChip(
                                        label: 'Good Product',
                                        selected: false,
                                        onSelected: (selected) {},
                                      ),
                                      SizedBox(width: 8),
                                      CustomFilterChip(
                                        label: 'Good Experience',
                                        selected: true,
                                        onSelected: (selected) {},
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return ReviewItem(review: reviews[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )));
  }

  void _showAddToCartDialog(BuildContext context, Product product) {
    int selectedQuantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add to Cart"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Quantity:"),
              DropdownButton<int>(
                value: selectedQuantity,
                items: List.generate(10, (index) => index + 1)
                    .map((quantity) => DropdownMenuItem<int>(
                          value: quantity,
                          child: Text(quantity.toString()),
                        ))
                    .toList(),
                onChanged: (int? value) {
                  if (value != null) {
                    selectedQuantity = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addToCart(product, selectedQuantity);
                addToHistory(widget.product);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              child: Text("Add to Cart"),
            ),
          ],
        );
      },
    );
  }

  void addToCart(Product product, int quantity) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .add({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imagePath,
        'category': product.category,
        'quantity': quantity,
        'timestamp': DateTime.now(),
      });
      CollectionReference orderTrackingRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order_tracking');
      await orderTrackingRef.add({
        'productId': cartRef.id,
        'status': ['To pay', 'To ship', 'To review'],
        'price': product.price,
        'quantity': quantity,
        'imageUrl': product.imagePath,
        'timestamp': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }
}
