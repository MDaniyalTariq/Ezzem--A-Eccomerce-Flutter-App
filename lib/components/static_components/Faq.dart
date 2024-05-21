import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          FAQItem(
            question: 'What types of gloves do you offer?',
            answer:
                'We offer a variety of gloves, including winter gloves, leather gloves, touchscreen gloves, and more...',
          ),
          FAQItem(
            question: 'How to choose the right size for jackets?',
            answer:
                'To choose the right size for jackets, measure your chest and refer to our size chart for accurate sizing information...',
          ),
          FAQItem(
            question: 'Do you offer international shipping?',
            answer:
                'Yes, we offer international shipping to most countries. Please check our shipping policy for more details...',
          ),
          FAQItem(
            question: 'What is your return policy?',
            answer:
                'Our return policy allows you to return items within 30 days of purchase for a full refund. Please refer to our return policy for detailed instructions...',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Color(0xFFF82249),
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey[200]!],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
