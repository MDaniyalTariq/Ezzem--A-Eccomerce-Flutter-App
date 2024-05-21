import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String) onItemClicked; // Callback function

  CustomSection({
    required this.title,
    required this.items,
    required this.onItemClicked, // Callback function added
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF82249).withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(5.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      _buildRow(
                        context,
                        items[index]['icon'],
                        items[index]['text'],
                      ),
                      SizedBox(width: 8),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String text) {
    return Container(
      width: 100,
      child: TextButton(
        onPressed: () {
          onItemClicked(text); // Trigger callback function with text as parameter
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ClickableIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;

  ClickableIconButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  _ClickableIconButtonState createState() => _ClickableIconButtonState();
}

class _ClickableIconButtonState extends State<ClickableIconButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isClicked = !isClicked;
        });
        widget.onPressed();
      },
      icon: Icon(widget.icon,
          color: isClicked ? Color(0xFFF82249) : Colors.black),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String buttonText;
  final String exampleText;
  final VoidCallback onButtonClick;

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.buttonText,
    required this.exampleText,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: onButtonClick,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool)? onSelected;

  CustomFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Text(label),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: selected ? Colors.green : Colors.blue,
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      selectedColor: Colors.green,
      checkmarkColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
