import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzem/authentication/login_or_registerPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ContentSection extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onButtonPressed;

  ContentSection({
    required this.text,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF82249),
            foregroundColor: Colors.white,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}

class WishlistHistoryNavigation extends StatefulWidget {
  final ValueChanged<int> onTap;

  WishlistHistoryNavigation({
    required this.onTap,
  });

  @override
  _WishlistHistoryNavigationState createState() =>
      _WishlistHistoryNavigationState();
}

class _WishlistHistoryNavigationState extends State<WishlistHistoryNavigation> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  late List<Map<String, dynamic>> wishlistItems;
  late List<Map<String, dynamic>> historyItems;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 16.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                _buildNavLink('Wishlist', 0),
                SizedBox(width: 8.0),
                _buildNavLink('History', 1),
              ],
            ),
            _buildContentContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String text, int index) {
    return InkWell(
      onTap: () {
        widget.onTap(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  index == _selectedIndex ? Colors.black : Colors.transparent,
              width: index == _selectedIndex ? 2.0 : 0.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: index == _selectedIndex ? Colors.black : Colors.black87,
                fontSize: index == _selectedIndex ? 16.0 : 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: 2.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentContainer() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (!_isLoggedIn && _selectedIndex == 0)
            ContentSection(
              text: 'View Your Wishlist by logging in to your account.',
              buttonText: 'Sign in or Register',
              onButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginOrRegisterPage(),
                  ),
                );
              },
            ),
          if (_isLoggedIn) _buildLoggedInContent(),
          if (!_isLoggedIn && _selectedIndex == 1)
            ContentSection(
              text: 'View Your History by logging in to your account.',
              buttonText: 'Sign in or Register',
              onButtonPressed: () {
                print('Login button clicked');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoggedInContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildLoggedInWishlistContent();
      case 1:
        return _buildLoggedInHistoryContent();
      default:
        return SizedBox(); 
    }
  }

Widget _buildLoggedInWishlistContent() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return Text('Error: User is not logged in.');
  }

  return Column(
    children: [
      SizedBox(height: 8),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('wishlist')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No items in wishlist');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(doc['imageUrl'] ?? ''),
                ),
                title: Text(
                  doc['name'] ?? '',
                  style: TextStyle(fontSize: 16.0),
                ),
                subtitle: Text(
                  '\$${doc['price'] ?? ''}',
                  style: TextStyle(fontSize: 14.0),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    _removeFromWishlist(doc);
                  },
                  child: Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              );
            }).toList(),
          );
        },
      ),
      SizedBox(height: 16),
    ],
  );
}



  Widget _buildLoggedInHistoryContent() {
    final currentUser = FirebaseAuth.instance.currentUser;
    String _formatTimestamp(Timestamp? timestamp) {
      if (timestamp != null) {
        DateTime dateTime = timestamp.toDate();
        return DateFormat.yMd().add_jm().format(dateTime);
      } else {
        return '';
      }
    }

    if (currentUser == null) {
      return Text('Error: User is not logged in.');
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .collection('history')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No items in history');
              }
      
              historyItems = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
      
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: historyItems.map((data) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data['imageUrl'] ?? ''),
                    ),
                    title: Text(
                      data['name'] ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      '\$${data['price'] ?? ''}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                     trailing: Text(
                      '${_formatTimestamp(data['timestamp'])}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

 void _removeFromWishlist(DocumentSnapshot itemSnapshot) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(itemSnapshot.id) 
        .delete();

    setState(() {
      wishlistItems.removeWhere((element) => element['id'] == itemSnapshot.id);
    });
  } catch (error) {
    print('Error removing item from wishlist: $error');
  }
}

}
