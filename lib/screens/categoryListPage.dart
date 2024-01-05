import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var categories = snapshot.data!.docs;

          List<Widget> categoryWidgets = [];
          for (var category in categories) {
            var categoryName = category['categoryName'];
            var categoryWidget = ListTile(
              title: Text(categoryName),
              // You can add more UI customization here if needed.
            );
            categoryWidgets.add(categoryWidget);
          }

          return ListView(
            children: categoryWidgets,
          );
        },
      ),
    );
  }
}
