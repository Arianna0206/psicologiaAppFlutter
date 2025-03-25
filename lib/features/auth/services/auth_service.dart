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

  Future<User?> registerWithEmailPassword(String displayName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // **Actualizar el perfil del usuario en Firebase Authentication**
        await user.updateDisplayName(displayName);
        await user.reload(); // Recargar datos del usuario

        // Obtener la última instancia del usuario actualizado
        user = _auth.currentUser;

        if (user == null) {
          _logger.e("Error: el usuario es nulo después de recargar.");
          return null;
        }

        // **Guardar el usuario en Firestore**
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'displayName': displayName,
          'email': email,
          'role': 'student',
          'picture': user.photoURL ?? '',
        });

        _logger.i("Usuario registrado y guardado en Firestore");
      }

      return user;
    } catch (e) {
      _logger.e("Error al registrar usuario", error: e);
      return null;
    }
  }


  Future<void> _saveUserToFirestore(User user) async {
    try {
      print("UID del usuario autenticado: ${user.uid}");
      
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': user.displayName ?? 'No Name',
        'email': user.email ?? 'No Email',
        'picture': user.photoURL ?? 'No Picture',
        'role': 'student',
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

  Future<String> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc.exists ? userDoc['name'] ?? "Usuario" : "Usuario";
    }
    return "Usuario";
  }

}
