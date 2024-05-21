import 'package:flutter/material.dart';
import 'package:ezzem/samples/horizontal_coupon_example_1.dart';
import 'package:ezzem/samples/horizontal_coupon_example_2.dart';
import 'package:ezzem/samples/vertical_coupon_example.dart';

class CoupanPage extends StatelessWidget {
  const CoupanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coupon Cards')),
      body: const Padding(
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HorizontalCouponExample1(),
              SizedBox(height: 14),
              VerticalCouponExample(),
              SizedBox(height: 14),
              HorizontalCouponExample2(),
            ],
          ),
        ),
      ),
    );
  }
}