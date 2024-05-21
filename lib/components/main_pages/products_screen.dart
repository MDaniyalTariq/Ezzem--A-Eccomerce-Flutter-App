import 'package:ezzem/components/products_components/ApparelsPage.dart';
import 'package:ezzem/components/products_components/GlovePage.dart';
import 'package:ezzem/components/products_components/JacketPage.dart';
import 'package:ezzem/components/products_components/SurgicalPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            GlovesPage(),
            JacketsPage(),
            ApparelsPage(),
            SurgicalPage(),
          ],
        ),
        bottomNavigationBar: Container(
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.solidHandPointUp),
                text: 'Gloves',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.tshirt),
                text: 'Jackets',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.shoePrints),
                text: 'Apparel',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.syringe),
                text: 'Surgical',
              )
            ],
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}






