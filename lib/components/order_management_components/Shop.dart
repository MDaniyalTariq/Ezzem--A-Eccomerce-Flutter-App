import 'package:ezzem/components/products_components/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

enum ProductStatus { onSale, outOfStock, onDemand }

class _ShopPageState extends State<ShopPage> {
  int previousItemCount = 0;
  String selectedCategory = 'All';
  String searchText = '';
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  int currentPage = 1;
  int pageSize = 6;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchProductsFromFirestore();
    _scrollController.addListener(_scrollListener);
    previousItemCount = filteredProducts.length;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductsFromFirestore() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    allProducts = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product(
        data['name'],
        data['description'],
        data['price'],
        data['imageUrl'],
        data['category'],
        totalPurchases: data['totalPurchases'],
      );
    }).toList();

    filteredProducts = allProducts;
    setState(() {
      isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = startIndex + pageSize;
        endIndex =
            endIndex > allProducts.length ? allProducts.length : endIndex;

        filteredProducts.addAll(allProducts.sublist(startIndex, endIndex));
        _isLoadingMore = false;
        currentPage++;
      });
    });
  }

  void _loadPreviousItems() {
    setState(() {
      _isLoadingMore = true;
      currentPage--;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void filterProductsByCategory(String category) {
    setState(() {
      if (category == 'All') {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product.category == category)
            .toList();
      }
      selectedCategory = category;
    });
  }

  void searchProducts(String text) {
    setState(() {
      searchText = text;
      filteredProducts = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    endIndex =
        endIndex > filteredProducts.length ? filteredProducts.length : endIndex;

    List<Product> currentProducts =
        filteredProducts.sublist(startIndex, endIndex);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assests/shop.png'),
        title: Text('Shop By Ezzem'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearch(allProducts),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter by:'),
                      _buildCategoryDropdown(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sort by:'),
                      _buildSortDropdown(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: currentProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildProductCard(currentProducts[index]);
                  },
                ),
                if (_isLoadingMore)
                  Center(
// SpinKitRotatingCircle: A rotating circle animation.
// SpinKitDoubleBounce: Two bouncing circles animation.
// SpinKitWave: A wave animation.
// SpinKitWanderingCubes: Two wandering cubes animation.
// SpinKitFadingFour: Four fading squares animation.
// SpinKitFadingCube: A fading cube animation.
// SpinKitCircle: A spinning circle animation.
// SpinKitChasingDots: A chasing dots animation.
// SpinKitPulse: A pulsing animation.
// SpinKitThreeBounce: Three bouncing dots animation.
                    child: SpinKitFadingCube(
                      color: Color(0xFFF82249), 
                      size: 50.0, 
                      duration: Duration(
                          milliseconds: 1200),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<String>(
      value: selectedCategory,
      onChanged: (String? newValue) {
        if (newValue != null) {
          filterProductsByCategory(newValue);
        }
      },
      items: <String>[
        'All',
        'Gloves',
        'Jackets',
        'Surgical Instruments',
        'Apparels'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSortDropdown() {
    String selectedSortOption = 'Name';

    return DropdownButton<String>(
      value: selectedSortOption,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedSortOption = newValue;
          });
        }
      },
      items: <String>['Name', 'Price']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: SizedBox(
        height: double.infinity,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.network(
                    product.imagePath, 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Price: \$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              _buildProductStatusBanner(product.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductStatusBanner(ProductStatus status) {
    String bannerText = '';
    Color bannerColor = Colors.transparent;

    switch (status) {
      case ProductStatus.onSale:
        bannerText = 'SALE';
        bannerColor = Colors.red;
        break;
      case ProductStatus.outOfStock:
        bannerText = 'OUT OF STOCK';
        bannerColor = Colors.grey;
        break;
      case ProductStatus.onDemand:
        bannerText = 'ON DEMAND';
        bannerColor = Colors.blue;
        break;
      default:
        bannerText = '';
    }

    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0)),
        ),
        child: Text(
          bannerText,
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final int totalPurchases;

  Product(
    this.name,
    this.description,
    this.price,
    this.imagePath,
    this.category, {
    this.totalPurchases = 0,
  });

  ProductStatus get status {
    if (totalPurchases < 2) {
      return ProductStatus.outOfStock;
    } else if (totalPurchases >= 2 && totalPurchases <= 20) {
      return ProductStatus.onSale;
    } else {
      return ProductStatus.onDemand;
    }
  }
}

class ProductSearch extends SearchDelegate<Product> {
  final List<Product> products;

  ProductSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (products.isNotEmpty) {
          close(context, products.first);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Product> searchResults = query.isEmpty
        ? products
        : products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final Product product = searchResults[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> searchResults = query.isEmpty
        ? products
        : products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final Product product = searchResults[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }
}
