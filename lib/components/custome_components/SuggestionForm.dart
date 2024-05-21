import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ezzem/components/custome_components/validator.dart'; 

class FormFour extends StatefulWidget {
  @override
  _FormFourState createState() => _FormFourState();
}

class _FormFourState extends State<FormFour> with Validator {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final double minValue = 8.0;

  int experienceIndex = 0;

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  @override
  void initState() {
    _onCreated();
    super.initState();
  }

  void _onCreated() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTapEmoji(int index) {
    setState(() {
      experienceIndex = index;
    });
  }

  final Color activeColor = Colors.pink[400]!;
  final Color inActiveColor = Colors.grey[50]!;

  Widget _buildEmoji() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(1),
            icon: Icon(
              Icons.sentiment_very_dissatisfied,
              color: experienceIndex == 1 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(2),
            icon: Icon(
              Icons.sentiment_dissatisfied,
              color: experienceIndex == 2 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(3),
            icon: Icon(
              Icons.sentiment_satisfied,
              color: experienceIndex == 3 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(4),
            icon: Icon(
              Icons.sentiment_very_satisfied,
              color: experienceIndex == 4 ? activeColor : inActiveColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue),
      child: TextFormField(
        controller: _nameController,
        validator: usernameValidator,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
            labelText: 'Full  Name',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.text,
        validator: validateEmail,
        onChanged: (String value) {},
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
            labelText: 'Email',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
      child: TextFormField(
        controller: _messageController,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            border: InputBorder.none,
            labelText: 'Description',
            contentPadding: EdgeInsets.symmetric(horizontal: minValue),
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildTextBackground(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(2)),
      child: child,
    );
  }

  Future<void> _submitForm() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference suggestions =
          FirebaseFirestore.instance.collection('suggestions');

      await suggestions.add({
        'userId': userId,
        'name': _nameController.text,
        'email': _emailController.text,
        'description': _messageController.text,
        'experienceIndex': experienceIndex,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _showSuccessDialog();
      
    }
    ;
  }

  void _showSuccessDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your suggestion has been submitted successfully!'),
        duration: Duration(seconds: 2),
      ),
      
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient:
              LinearGradient(colors: [Colors.pink[700]!, Colors.pink[400]!])),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: minValue * 2.4),
          elevation: 0.0,
        ),
        child: Text('SAVE'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assests/arrangement-with-different-feelings.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.7)
          ])),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: minValue * 5,
                        ),
                        Text(
                          "Write Us",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48.0,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 110.0,
                          child: Container(
                            height: 4,
                            color: Colors.pink[400]!,
                          ),
                        ),
                        SizedBox(
                          height: minValue * 2,
                        ),
                        Text(
                          "Feel free to write us. We will get back\n to you as soon as we can.",
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[200]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: minValue * 7,
                        ),
                        Text(
                          "How was your experience?",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: minValue,
                        ),
                        _buildEmoji(),
                        SizedBox(
                          height: minValue * 4,
                        ),
                        _buildTextBackground(_buildName()),
                        SizedBox(
                          height: minValue * 2,
                        ),
                        _buildTextBackground(_buildEmail()),
                        SizedBox(
                          height: minValue * 2,
                        ),
                        _buildTextBackground(_buildDescription()),
                        SizedBox(
                          height: minValue * 6,
                        ),
                        _buildSubmitBtn()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
