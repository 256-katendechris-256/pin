
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service List'),
      ),
      body: _buildServiceList(),
    );
  }

  Widget _buildServiceList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<DocumentSnapshot> services = snapshot.data!.docs;

        return ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            var serviceData = services[index].data() as Map<String, dynamic>;
            var serviceName = serviceData['serviceName'];
            var description = serviceData['description'];
            var pricing = serviceData['pricing'];
            var category = serviceData['category'];
            var imageUrl1 = serviceData['imageUrls'][0];
            var imageUrl2 = serviceData['imageUrls'][1];

            return Card(
              elevation: 3,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(
                    imageUrl1, // You may need to adjust the field based on your data structure
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Image.network(
                    imageUrl2, // You may need to adjust the field based on your data structure
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(serviceName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: $description'),
                        Text('Pricing: $pricing'),
                        Text('Category: $category'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
