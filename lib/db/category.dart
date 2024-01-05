import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Category {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;



  void createCategory(String name) async {
    try {
      await _firestore.collection('categories').add({
        'categoryName': name,
      });
      print('Category created successfully!');
    } catch (e) {
      print('Error creating category: $e');
    }
  }


  Future<List<DocumentSnapshot>> getCategory() {
    return _firestore.collection('categories').get().then((snaps) {
      return snaps.docs;
    });
  }

  Future<bool> checkCategoryExists(String categoryName) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('categories')
        .where('categoryName', isEqualTo: categoryName)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getSuggestions(String suggestion) async {
    print('Querying for suggestion: $suggestion');
    final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
        .collection('categories')
        .where('categoryName', isEqualTo: suggestion)
        .get();

    print('Query result: ${snap.docs}');
    return snap.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data()!).toList();
  }

  void main() {

  }
}
