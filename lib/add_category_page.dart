import 'package:flutter/material.dart';


class AddCategory extends StatefulWidget {
  AddCategory({this.title});

  String title = "Choose category";

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  
  static List _categories = ["Shoes", "Shirt", "T-Shirt", "Pants", "Hat", 
                      "Gloves", "Hoodie", "Jacket", "Tie", "Dress", 
                      "Footwear", "Second-hand underwear", "Accesories",
                      "Dress", "Skirt", "Other", "Sam"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index <= _categories.length - 1){
            print(index + _categories.length);
            return ListTile(
              title: Text(_categories[index]),
              onTap: () {
                Navigator.pop(context, _categories[index]);
              }
            );
          }
        }
      )
    );
  }
}
