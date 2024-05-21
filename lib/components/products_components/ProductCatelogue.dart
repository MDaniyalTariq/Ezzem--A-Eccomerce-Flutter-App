import 'package:flutter/material.dart';

class Product {
  final String imagePath;
  final String name;
  final String code;
  final String category;

  final String description;

  Product(
      {required this.imagePath,
      required this.name,
      required this.code,
      required this.category,
      required this.description});
}

class ProductCatalog extends StatefulWidget {
  final List<String> categories;
  final Widget Function(BuildContext context, String category) itemBuilder;
  final List<Product> products;

  const ProductCatalog({
    Key? key,
    required this.categories,
    required this.itemBuilder,
    required this.products,
  }) : super(key: key);

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  String selectedCategory = 'All';
  String searchText = '';
  int _currentPage = 1;
  int _pageSize = 6;
  late Map<String, int> itemCountMap;

  @override
  void initState() {
    super.initState();
    itemCountMap = {};
    widget.products.forEach((product) {
      itemCountMap[product.category] =
          (itemCountMap[product.category] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = widget.products
        .where((product) =>
            (selectedCategory == 'All' ||
                product.category == selectedCategory) &&
            (searchText.isEmpty ||
                product.name.toLowerCase().contains(searchText.toLowerCase())))
        .toList();

    int totalPages = (filteredProducts.length / _pageSize).ceil();

    int startIndex = (_currentPage - 1) * _pageSize;
    int endIndex = startIndex + _pageSize;
    if (endIndex > filteredProducts.length) {
      endIndex = filteredProducts.length;
    }
    List<Product> currentPageProducts = filteredProducts.sublist(
      startIndex,
      endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: selectedCategory,
            items: [
              DropdownMenuItem<String>(
                value: 'All',
                child: Text('All (${widget.products.length})'),
              ),
              for (var entry in itemCountMap.entries)
                DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text('${entry.key} (${entry.value})'),
                ),
            ],
            onChanged: (String? value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.75,
            ),
            itemCount: currentPageProducts.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = currentPageProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDescription(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        product.imagePath,
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${product.code}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
            Text('Page $_currentPage of $totalPages'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _currentPage < totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class ProductDescription extends StatelessWidget {
  final Product product;

  const ProductDescription({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Product Code: ${product.code}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Category: ${product.category}',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${product.description}',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
