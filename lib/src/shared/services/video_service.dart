import 'package:firebase_storage/firebase_storage.dart';

class VideoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getVideoUrl(String filePath) async {
    try {
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      print("URL del video obtenida: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error al obtener URL del video: $e");
      return "";
    }
  }
}
