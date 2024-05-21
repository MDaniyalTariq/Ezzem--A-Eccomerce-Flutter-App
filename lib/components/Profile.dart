import 'package:ezzem/authentication/login_or_registerPage.dart';
import 'package:ezzem/components/order_management_components/AnimatedPage.dart';
import 'package:ezzem/components/order_management_components/Checkout.dart';
import 'package:ezzem/components/order_management_components/Coupan.dart';
import 'package:ezzem/components/static_components/Faq.dart';
import 'package:ezzem/components/settings/Settings.dart';
import 'package:ezzem/components/custome_components/SuggestionForm.dart';
import 'package:ezzem/components/custome_components/custom_widgets.dart';
import 'package:ezzem/components/main_pages/home_screen.dart';
import 'package:ezzem/components/main_pages/products_screen.dart';
import 'package:ezzem/components/order_management_components/wishlist_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: FirebaseAuth.instance.currentUser != null
                              ? null // Disable onPressed if user is logged in
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginOrRegisterPage(),
                                    ),
                                  );
                                },
                          child: Text(
                            FirebaseAuth.instance.currentUser != null
                                ? 'Welcome back!' // Show "Welcome back" if user is logged in
                                : 'Sign in or Register!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    FutureBuilder<String?>(
                      future: fetchCountry(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data == null) {
                          return const SpinKitFadingCube(
                            color: Color(0xFFF82249), // Customize color here
                            size: 20.0,
                          );
                        } else {
                          return FutureBuilder<Widget>(
                            future: getFlagIcon(snapshot.data!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SpinKitFadingCube(
                                  color:
                                      Color(0xFFF82249), // Customize color here
                                  size: 20.0,
                                );
                              } else {
                                return snapshot.data ??
                                    SizedBox(); // Display flag icon or empty SizedBox
                              }
                            },
                          );
                        }
                      },
                    ),
                    ClickableIconButton(
                      onPressed: () {
                        print("Notification button Clicked!");
                      },
                      icon: Icons.notifications,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                      },
                      icon: Icon(Icons.settings_sharp),
                    ),
                  ],
                ),
              ],
            ),
            CustomSection(
              title: 'My Orders',
              items: [
                {'icon': Icons.payment, 'text': 'To pay'},
                {'icon': Icons.local_shipping, 'text': 'To ship'},
                {'icon': Icons.airport_shuttle, 'text': 'Shipped'},
                {'icon': Icons.star_rate, 'text': 'To review'},
              ],
              onItemClicked: (text) {
                // Navigate to animated page with order type as parameter
                _navigateToAnimatedPage(context, text);
              },
            ),
            _buildOrderBanner(context),
            CustomSection(
              title: 'Payments & Discounts',
              items: [
                {'icon': Icons.credit_card_outlined, 'text': 'Cards'},
                {'icon': Icons.local_offer_outlined, 'text': 'Coupons'},
              ],
              onItemClicked: (text) {
                _handleItemClick(context, text);
              },
            ),
            CustomSection(
              title: 'Services',
              items: [
                {'icon': Icons.headset_mic_outlined, 'text': 'Help Center'},
                {
                  'icon': Icons.mode_edit_outline_outlined,
                  'text': 'Suggestions'
                },
                {'icon': Icons.live_help_outlined, 'text': 'Q&A'},
              ],
              onItemClicked: (text) {
                _handleItemClick(context, text);
              },
            ),
            WishlistHistoryNavigation(
              onTap: (index) {
                print('Clicked index: $index');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAnimatedPage(BuildContext context, String orderType) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return AnimatedPage(
          orderType: orderType,
          mWidth: MediaQuery.of(context).size.width,
          mHeight: MediaQuery.of(context).size.height,
        );
      },
    );
  }

  void _handleItemClick(BuildContext context, String text) {
    switch (text) {
      case 'Cards':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDemoPage()),
        );
        break;
      case 'Coupons':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoupanPage()),
        );
        break;
      case 'Help Center':
       openWhatsApp(context); 
        break;

      case 'Suggestions':
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FormFour())        );
        break;
      case 'Q&A':
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQPage())        );
        break;
      default:
        // Handle other cases if needed
        break;
    }
  }
}

Future<Widget> getFlagIcon(String countryName) async {
  Map<String, String> countryCodes = {
    'pakistan': 'pk',
  };
  String? countryCode = countryCodes[countryName.toLowerCase()];
  if (countryCode == null) {
    print('Country code not found for $countryName');
    return SizedBox();
  }

  print(countryCode);
  String code = countryCode.toLowerCase();
  print(code);
  final url = 'https://flagcdn.com/20x15/$code.png';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Image.memory(response.bodyBytes, width: 40, height: 30);
    } else {
      print('Failed to fetch flag icon: ${response.statusCode}');
      return SizedBox();
    }
  } catch (e) {
    print('Error fetching flag icon: $e');
    return SizedBox();
  }
}

Future<String?> fetchCountry() async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied.');
      return '';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      return placemarks[0].country;
    } else {
      print('Unable to fetch country.');
      return '';
    }
  } catch (e) {
    print('Error fetching country: $e');
    return '';
  }
}

Widget _buildOrderBanner(BuildContext context) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            'assests/banner.jpg',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      ));
}
