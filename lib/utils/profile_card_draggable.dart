import 'package:flutter/material.dart';

class ProfileCardDraggable extends StatelessWidget
{
  final int cardNum;
  String category;
  String description;
  String imageUrl;

  ProfileCardDraggable(this.cardNum, this.category, this.description, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Image.network((imageUrl != null) ? imageUrl
              :"https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png", fit: BoxFit.fill),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300))
            ),
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Card number: $cardNum', style:  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)),
                      Padding(padding:  EdgeInsets.only(bottom: 8.0)),
                      Text('Description: $description', textAlign: TextAlign.start),
                      Padding(padding:  EdgeInsets.only(bottom: 8.0)),
                      Text('Category: $category', textAlign: TextAlign.start),
                    ],
                  ),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {},
                  child:  Icon(
                    Icons.info,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0),
                )
              ],
            ))
              ],
            )
          ),

        ],
      ),
    );
  }
}