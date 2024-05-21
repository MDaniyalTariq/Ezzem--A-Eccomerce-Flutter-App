import 'dart:async';
import 'package:ezzem/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/Theme_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);
            return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark().copyWith(
                textTheme: ThemeData.dark().textTheme.apply(
                      bodyColor: Colors.white, 
                    ),
              ),
              debugShowCheckedModeBanner: false,
              title: 'Ezzem',
              home: MainWidget(),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 26, 26),
      body: Center(
        child: Image.asset(
          'assests/logo.png',
          width: 200.0,
          height: 200.0,
        ),
      ),
    );
  }
}
