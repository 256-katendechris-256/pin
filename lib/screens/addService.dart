import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tmw/db/service.dart';


import '../db/category.dart';


class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  Category _category = Category();
  serviceHandler _serviceHandler =serviceHandler();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController pricingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  late String _currentCategory='';
  Color white = Colors.white;
  Color black = Colors.black;
  Color red = Colors.red;
  File? _imageFile1;
  File? _imageFile2;

  bool isLoading =false;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _pickImage1() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile1 = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile2 = File(pickedFile.path);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
      Navigator.of(context).pop();
      return true;
    },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            leading: IconButton(
              icon: Icon(Icons.close, color: black),
              onPressed: () {
                Navigator.of(context).pop(); // This line will navigate back to the previous screen
              },
            ),
            title: Text("Add Service", style: TextStyle(color: black)),
          ),

          body: Form(
            key: _formKey,
            child: isLoading?CircularProgressIndicator(): ListView(
              children: <Widget>[
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: _buildImagePicker(_imageFile1, _pickImage1, 'Add Image 1'),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(5, 0, 4, 2)),
                    Expanded(
                      child: _buildImagePicker(_imageFile2, _pickImage2, 'Add Image 2'),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 2, 4, 0)),
                  ],
                ),

                //_buildErrorMessage('Enter a service name with at most 10 characters'),
                _buildTextField('Service Name', serviceNameController),
                _buildDescriptionField(),
                _buildPricingField(),
                _buildCategoryRow(),
                ElevatedButton(onPressed: (){
                  validateAndUpload();
                },
                    child: Text('Add Service')),
                //_buildSubmitButton(),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildImagePicker(File? imageFile, Function() pickImage, String label) {
    return InkWell(
      onTap: pickImage as void Function()?,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: imageFile != null
            ? Image.file(imageFile, fit: BoxFit.cover)
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.add, size: 40, color: Colors.grey),
                onPressed: pickImage as void Function()?,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(message, style: TextStyle(color: red)),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          TextFormField(

            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hintText),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Service name is required';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: descriptionController,
            maxLines: null, // Allows for multiline input
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter description here...',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Description is required';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingField() {
    return Padding(
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          TextFormField(
            controller: pricingController,
            keyboardType: TextInputType.number, // Only numeric keyboard
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Price'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Price is required';
              } else if (!isNumeric(value)) {
                return 'Enter a valid numeric value for price';
              }
            },
          ),
        ],
      ),
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            onTap: () {
              _showCategoryPicker();
            },
            controller: TextEditingController(text: _currentCategory),
            decoration: InputDecoration(
              hintText: 'Select Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Category is required';
              }
            },
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = (categories[index].data() as Map<String, dynamic>)['categoryName'] ?? '';
              return ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    _currentCategory = (categories[index].data() as Map<String, dynamic>)['categoryName'] ?? '';

                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = [];

    for (int i = 0; i < categories.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Text((categories[i].data() as Map<String, dynamic>)['category'] ?? ''),
          value: (categories[i].data() as Map<String, dynamic>)['categoryName'],
        ),
      );
    }

    // Print items for debugging
    print('Dropdown items: $items');

    return items;
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _category.getCategory();
    print(data.length);
    setState(() {
      categories = data;
      if (categories.isNotEmpty) {
        //_currentCategory = (categories[0].data() as Map<String, dynamic>?)?['category'];
        _currentCategory = (categories[0].data() as Map<String, dynamic>?)?['category'] ?? '';
      }
    });
  }



  /*Future<void> validateAndUpload() async {
    setState(() => isLoading = true);

    if (_formKey.currentState!.validate()) {
      if (_imageFile1 != null && _imageFile2 != null) {
        String imageUrl1;
        String imageUrl2;

        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 = '${DateTime.now().millisecondsSinceEpoch.toString()}_1.jpg';
        final String picture2 = '${DateTime.now().millisecondsSinceEpoch.toString()}_2.jpg';

        try {
          // Use async/await to wait for both image uploads to complete
          TaskSnapshot snapshot1 = await storage.ref().child(picture1).putFile(_imageFile1!);
          TaskSnapshot snapshot2 = await storage.ref().child(picture2).putFile(_imageFile2!);

          // Check if the image uploads were successful
          if (snapshot1.state == TaskState.success && snapshot2.state == TaskState.success) {
            // Get download URLs for the images
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();

            List<String> imageList = [imageUrl1, imageUrl2];

            // Use await when calling uploadService to ensure it completes before moving on
            await _serviceHandler.uploadService(
              serviceName: serviceNameController.text,
              description: descriptionController.text,
              category: _currentCategory,
              price: int.parse(pricingController.text),
              imageUrls: imageList,
            );

            _formKey.currentState!.reset();
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'Service added');
          } else {
            // Handle error when image uploads fail
            Fluttertoast.showToast(msg: 'Error uploading images. Please try again.');
          }
        } catch (e) {
          // Handle other potential errors during the upload process
          setState(() => isLoading = false);
          print('Error during image upload: $e');
          Fluttertoast.showToast(msg: 'Error adding service. Please try again.');
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'Provide both images');
      }
    }
  }*/


  Future<void> validateAndUpload() async {
    setState(() => isLoading = true);

    if (_formKey.currentState!.validate()) {
      if (_imageFile1 != null && _imageFile2 != null) {
        String imageUrl1;
        String imageUrl2;

        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 = '${DateTime.now().millisecondsSinceEpoch.toString()}_1.jpg';
        final String picture2 = '${DateTime.now().millisecondsSinceEpoch.toString()}_2.jpg';

        try {
          // Use async/await to wait for both image uploads to complete
          TaskSnapshot snapshot1 = await storage.ref().child(picture1).putFile(_imageFile1!);
          TaskSnapshot snapshot2 = await storage.ref().child(picture2).putFile(_imageFile2!);

          // Check if the image uploads were successful
          if (snapshot1.state == TaskState.success && snapshot2.state == TaskState.success) {
            // Get download URLs for the images
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();

            List<String> imageList = [imageUrl1, imageUrl2];

            // Use await when calling uploadService to ensure it completes before moving on
            await _serviceHandler.uploadService(
              serviceName: serviceNameController.text,
              description: descriptionController.text,
              category: _currentCategory,
              price: int.parse(pricingController.text),
              imageUrls: imageList,
            );

            _formKey.currentState!.reset();
            setState(() => isLoading = false);
            Fluttertoast.showToast(msg: 'Service added');
          } else {
            // Handle error when image uploads fail
            Fluttertoast.showToast(msg: 'Error uploading images. Please try again.');
          }
        } catch (e) {
          // Handle other potential errors during the upload process
          setState(() => isLoading = false);
          print('Error during image upload: $e');
          Fluttertoast.showToast(msg: 'Error adding service. Please try again.');
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: 'Provide both images');
      }
    }
  }


}
