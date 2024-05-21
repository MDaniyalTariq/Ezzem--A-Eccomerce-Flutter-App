import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ezzem/components/products_components/ApparelsPage.dart';
import 'package:ezzem/components/products_components/GlovePage.dart';
import 'package:ezzem/components/products_components/JacketPage.dart';
import 'package:ezzem/components/products_components/SurgicalPage.dart';
import 'package:ezzem/components/order_management_components/wishlist_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../order_management_components/Cart.dart';
import '../static_components/Faq.dart';
import '../Profile.dart';
import '../order_management_components/Shop.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ShopPage(),
            FAQPage(),
            WishlistHistoryNavigation(onTap: (index) {
              print('Clicked index: $index');
            }),
            CartPage(),
            ProfilePage(),
          ],
        ),
        floatingActionButton: Tooltip(
          message: 'Need assistance?', 
          child: FloatingActionButton(
            onPressed: () {
              openWhatsApp(context);
            },
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              size: 30,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: Container(
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.infoCircle),
                text: 'FAQs',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.solidStar),
                text: 'Wishlist',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.shoppingCart),
                text: 'Cart',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.users),
                text: 'Account',
              ),
            ],
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}

void openWhatsApp(BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    String phoneNumber = '+923019659063';
    String message = 'Hello! I need assistance.';
    String encodedMessage = Uri.encodeQueryComponent(message);
    String url = 'https://wa.me/$phoneNumber/?text=$encodedMessage';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error opening WhatsApp: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening WhatsApp. Please try again later.'),
        ),
      );
    }
  }
}

// ignore: must_be_immutable
class HomeContentPage extends StatelessWidget {
  final List<Map<String, String>> imageData = [
    {
      'path': 'assests/pexels-luis-quintero-1659749.jpg',
      'title': 'Title 1',
      'heading': 'Discover our Gloves Collection!',
      'paragraph':
          'Stay Cozy and Protected! Variety of materials and Styles-Perfect Fit for every Occasion',
    },
    {
      'path': 'assests/pexels-beyzaa-yurtkuran-17117486.jpg',
      'title': 'Title 2',
      'heading': 'Explore our Jackets Range!',
      'paragraph':
          'Warmth meets Fashion! Quality materials for Durabilty-Find your perfect Outerwear',
    },
    {
      'path': 'assests/pexels-antonio-sokic-3839432.jpg',
      'title': 'Title 3',
      'heading': 'Browse through our Apparel!',
      'paragraph':
          'Fashion-Forward Clothing! Diverse Styles for all Tastes-Elevate your Wardrobe',
    },
    {
      'path': 'assests/pexels-cottonbro-studio-7585320 (1).jpg',
      'title': 'Title 4',
      'heading': 'Precision Surgical Instruments!',
      'paragraph':
          'Precision for Medical Professionals! High-Quality tolls for Surgery-Ensuring Patient Safety',
    },
  ];
  final List<Map<String, String>> coreValues = [
    {
      'title': 'Our Vision',
      'description':
          'To Become The Premier Manufacturer Of Garments, Gloves, Socks, And Bed Sheets',
      'icon': '⭐',
    },
    {
      'title': 'Our Mission',
      'description':
          'Our Customers Are At The Heart Of Our Business, And Their Satisfaction Is Our Ultimate Goal.We Are Dedicated To Being',
      'icon': '⭐',
    },
    {
      'title': 'Quality',
      'description':
          'We Continuously Improve Our Quality System And Provide Access To Accurate, Essential Information Through High – Quality Product.',
      'icon': '⭐',
    },
    {
      'title': 'Teamwork',
      'description':
          'We Demonstrate Effective Teamwork By Providing The Necessary Support For Each Other And Making The Most Of Our Differences In Knowledge.',
      'icon': '⭐',
    },
  ];
  List<Widget> pages = [
    GlovesPage(),
    JacketsPage(),
    ApparelsPage(),
    SurgicalPage(),
  ];

  HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: imageData.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> data = entry.value;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pages[index],
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(data['path']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['heading']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            data['paragraph']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20.0),
        DividerSection(
          divisionsData: [
            {
              'title': 'Gloves',
              'imagePath': 'assests/pexels-dom-j-45057 (1).jpg',
            },
            {
              'title': 'Jackets',
              'imagePath': 'assests/pexels-ali-babajahdi-16341730.jpg',
            },
            {
              'title': 'Apparels',
              'imagePath': 'assests/pexels-ylanite-koppens-934070.jpg',
            },
            {
              'title': 'Surgical Instruments',
              'imagePath': 'assests/pexels-karolina-grabowska-6627704.jpg',
            },
          ],
        ),
        SizedBox(height: 20.0),
        CoreValuesSection(coreValues: coreValues),
      ],
    ));
  }
}

class CoreValuesSection extends StatelessWidget {
  final List<Map<String, String>> coreValues;

  CoreValuesSection({required this.coreValues});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Our Core Values',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Guiding principles that define our culture and beliefs!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: coreValues.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CoreValueRow(
                      title: coreValues[index]['title']!,
                      description: coreValues[index]['description']!,
                      icon: coreValues[index]['icon']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CoreValueRow extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  CoreValueRow({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DividerSection extends StatelessWidget {
  final List<Map<String, String>> divisionsData;

  DividerSection({required this.divisionsData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              // ignore: deprecated_member_use
              child: TyperAnimatedTextKit(
                isRepeatingAnimation: false,
                speed: Duration(milliseconds: 100),
                text: ['Ezzem Enterprises Division'],
                textStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: divisionsData.map((data) {
                return DivisionWidget(
                  title: data['title']!,
                  imageAssetPath: data['imagePath']!,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DivisionWidget extends StatelessWidget {
  final String title;
  final String imageAssetPath;

  DivisionWidget({
    required this.title,
    required this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.0,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Image.asset(
              imageAssetPath,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
