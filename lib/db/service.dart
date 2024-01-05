import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../db/category.dart';
import 'package:tmw/screens/addService.dart';

/*class serviceHandler{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref ='services';

  /*void uploadService({
    required String serviceName,
    required String description,
    required String category,
    required int price,
    required List<String> imageUrls,
  }) async {
    try {
      var id = Uuid();
      String serviceId = id.v1();

      await _firestore.collection(ref).doc(serviceId).set({
        'serviceName': serviceName,
        'description': description,
        'category': category,
        'price': price,
        'imageUrls': imageUrls,
      });

      print('Service added successfully!');
    } catch (e) {
      print('Error adding service: $e');
    }
  }*/
  Future<void> uploadService({
    required String serviceName,
    required String description,
    required String category,
    required int price,
    required List<String> imageUrls,
  }) async {
    try {
      var id = Uuid();
      String serviceId = id.v1();

      await _firestore.collection(ref).doc(serviceId).set({
        'serviceName': serviceName,
        'description': description,
        'category': category,
        'price': price,
        'imageUrls': imageUrls,
      });

      print('Service added successfully!');
    } catch (e) {
      print('Error adding service: $e');
    }
  }


}*/
class serviceHandler {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'services';
  late Category _category;

  Future<void> uploadService({
    required String serviceName,
    required String description,
    required String category,
    required int price,
    required List<String> imageUrls,
  }) async {
    try {
      var id = Uuid();
      String serviceId = id.v1();

      // Check if the category exists, create it if it doesn't
      bool categoryExists = await _category.checkCategoryExists(category);
      if (!categoryExists) {
        _category.createCategory(category);
      }

      // Add a new service document within the "services" collection under the specified category
      await _firestore.collection('categories').doc(category).collection('services').doc(serviceId).set({
        'serviceName': serviceName,
        'description': description,
        'price': price,
        'imageUrls': imageUrls,
      });

      print('Service added successfully!');
    } catch (e) {
      print('Error adding service: $e');
    }
  }
}