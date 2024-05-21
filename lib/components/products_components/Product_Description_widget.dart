import 'package:flutter/material.dart';

class ProductDescriptionWidget extends StatefulWidget {
  final String description;

  ProductDescriptionWidget({required this.description});

  @override
  _ProductDescriptionWidgetState createState() =>
      _ProductDescriptionWidgetState();
}

class _ProductDescriptionWidgetState extends State<ProductDescriptionWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.justify,
              maxLines: isExpanded ? 100 : 4,
            ),
            SizedBox(height: 8.0),
            if (!isExpanded)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'More...',
                  style: TextStyle(
                    color: Theme.of(context)
                        .primaryColor, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
