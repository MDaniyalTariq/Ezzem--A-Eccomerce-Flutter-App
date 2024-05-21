import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzem/authentication/login_or_registerPage.dart';
import 'package:ezzem/components/main_pages/BookOnline.dart';
import 'package:ezzem/components/main_pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezzem/components/main_pages/about_us_screen.dart';
import 'package:ezzem/components/custome_components/header.dart';
import 'package:ezzem/components/main_pages/home_screen.dart';
import 'package:ezzem/components/main_pages/products_screen.dart';
import 'package:ezzem/components/settings/Theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ezzem',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CustomHeader(
          onItemTapped: (int index) {},
          itemCountStream: getTotalItemCount(),
        ),
        drawer: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.grey.shade900],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.black87, Color(0xFFF82249)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                        SizedBox(height: 5),
                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.email!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              );
                            } else {
                              return Text(
                                'Guest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _onItemTapped(0),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.white),
                  title: Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _onItemTapped(1),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _onItemTapped(2),
                ),
                ListTile(
                  leading: Icon(Icons.book, color: Colors.white),
                  title: Text(
                    'Book Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _onItemTapped(3),
                ),
                ListTile(
                  leading: Icon(Icons.business, color: Colors.white),
                  title: Text(
                    'Explore Our Business',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _onItemTapped(4),
                ),
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                      );
                    } else {
                      return ListTile(
                        leading: Icon(Icons.login, color: Colors.white),
                        title: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginOrRegisterPage(),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            HomePage(),
            ProductsPage(),
            AboutUsPage(),
            BookOnlinePage(),
            HomeContentPage()
          ],
        ),
      ),
    );
  }

  Stream<int> getTotalItemCount() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart')
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } else {
      return Stream.value(0);
    }
  }
}
