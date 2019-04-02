import 'package:flutter/material.dart';

class SoldItemsPage extends StatefulWidget {
  @override
  _SoldItemsPageState createState() => _SoldItemsPageState();
}

class _SoldItemsPageState extends State<SoldItemsPage> {

  //Put Product object in parameter
  Widget soldItem(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(15),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.grey[200],   
          width: 1
        )
      ),
      child: Row(
        children: <Widget>[
          Image.network("https://via.placeholder.com/150"),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      customText("Category"),
                      customText("Brand"),
                      customText("Size")
                    ], 
                  ),
                  customText("Location"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customText(String text){
    return Text(
      text,
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 16
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RawMaterialButton(
          child:Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Sold Items"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: <Widget>[
          Text("Sold items: 4", style: TextStyle(fontSize: 20),),
          soldItem(),
          soldItem(),
          soldItem(),
          soldItem()
        ],
      ),
    );
  }
}