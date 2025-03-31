import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioService audioService = AudioService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> playAudio(String filePath) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("No hay usuario autenticado. Debes iniciar sesión.");
        return;
      }

      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      print("URL del audio: $downloadUrl");

      await _audioPlayer.setUrl(downloadUrl);
      _audioPlayer.play();
      print("Reproduciendo audio...");
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  Future<void> playAudioFromUrl(String downloadUrl) async {
    try {
      await _audioPlayer.setUrl(downloadUrl);
      _audioPlayer.play();
      print("Reproduciendo audio desde URL directa...");
    } catch (e) {
      print("Error al reproducir el audio desde URL: $e");
    }
  }


  void stopAudio() {
    _audioPlayer.stop();
  }
}
