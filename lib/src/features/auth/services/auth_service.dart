import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger(); 

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i("Inicio de sesión cancelado por el usuario");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToFirestore(user);
      }

      _logger.i("Inicio de sesión exitoso: ${user?.displayName}");
      return user;
    } catch (e) {
      _logger.e("Error durante el inicio de sesión con Google", error: e);
      return null;
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': user.displayName ?? 'No Name',
        'email': user.email ?? 'No Email',
        'picture': user.photoURL ?? 'No Picture',
      }, SetOptions(merge: true));
      _logger.i("Usuario guardado en Firestore");
    } catch (e) {
      _logger.e("Error al guardar el usuario en Firestore", error: e);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _logger.i("Sesión cerrada");
    } catch (e) {
      _logger.e("Error cerrando sesión", error: e);
    }
  }

  User? get currentUser => _auth.currentUser;
}
