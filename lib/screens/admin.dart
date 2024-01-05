import 'package:flutter/material.dart';
import 'package:tmw/screens/addService.dart';
import 'package:tmw/screens/serviceListPage.dart';
import 'package:tmw/screens/categoryListPage.dart';
import '../db/category.dart';
//import 'categoryListPage.dart';
import 'package:fluttertoast/fluttertoast.dart';




enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.blue;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  Category _categoryService = Category();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                        _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: TextButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 50.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.category),
                              label: Text("Category")),
                          subtitle: Text(
                            '23',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 50.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Offers")),
                          subtitle: Text(
                            '120',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 50.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Done")),
                          subtitle: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 50.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 50.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close,color: Colors.red,),
                              label: Text("Cancel",style: TextStyle(color: Colors.red),)),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red, fontSize: 50.0,),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add service"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddService()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Service list"),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceListPage()),
              );
            },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>CategoryListPage()),
                );
              },
            ),


            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() async {
    var alert = AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Category cannot be empty';
            }
            return null; // Return null for no validation error
          },
          decoration: InputDecoration(
            hintText: "Add category",
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (_categoryFormKey.currentState!.validate()) {
              // If the form is valid, check if the category already exists
              bool categoryExists = await _categoryService.checkCategoryExists(categoryController.text);

              if (categoryExists) {
                Fluttertoast.showToast(msg: 'Category already exists');
              } else {
                // If the category doesn't exist, add it
                _categoryService.createCategory(categoryController.text);
                Fluttertoast.showToast(msg: 'Category created');
                Navigator.pop(context);
              }
            }
          },
          child: Text('ADD'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }




}
