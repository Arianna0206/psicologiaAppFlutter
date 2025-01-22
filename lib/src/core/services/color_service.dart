import 'package:cloud_firestore/cloud_firestore.dart';


class ColorService {
  Stream<List<Map<String, dynamic>>> fetchColors() {
    CollectionReference collection = FirebaseFirestore.instance.collection("public");
    return collection.snapshots().map((QuerySnapshot snapshot) {
      List<Map<String, dynamic>> colorList = [];
      snapshot.docs.forEach((doc) {
        colorList.add(doc.data() as Map<String, dynamic>);
      });
      return colorList;
    });
  }
  Stream<List<Map<String, dynamic>>> Categories(){
    CollectionReference collection = FirebaseFirestore.instance.collection("users");
    return collection.snapshots().map((QuerySnapshot snapshot){
      List<Map<String, dynamic>> categories = [];
      snapshot.docs.forEach((doc){
        categories.add(doc.data() as Map<String, dynamic>);
      });
      return categories;
    });
  }
}


