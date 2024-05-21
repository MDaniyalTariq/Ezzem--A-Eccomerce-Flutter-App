import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  Future<User?> signInWithGoogle() async {
    try {
      // Create a GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // Check if user canceled the sign-in process
      if (googleSignInAccount == null) {
        print('Google sign-in canceled');
        return null; // Return null if sign-in was canceled
      }

      // Obtain authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      // Create GoogleAuthProvider credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the GoogleAuthProvider credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the user from the UserCredential
      return userCredential.user;
    } catch (error) {
      // Handle any errors
      print("Error signing in with Google: $error");
      return null;
    }
  }
}
