import "package:flutter/material.dart";
import 'cards_section_draggable.dart';
import 'add_product_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';

class MarketPage extends StatefulWidget {
  final Widget child;
  GoogleSignInAccount user;

  MarketPage({Key key, this.child, this.user}) : super(key: key);

  _MarketPageState createState() => _MarketPageState(user);
}

class _MarketPageState extends State<MarketPage> {

  _MarketPageState(this.user);
  GoogleSignInAccount user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {},
                  child:  Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0),
                ),
                RawMaterialButton(
                  onPressed: () {},
                  child:  Icon(
                    Icons.sms,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0),
                )
              ],
            )
          ),
          CardsSectionDraggable(),
          Container(
            color: Colors.grey.shade200,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RawMaterialButton(
                  fillColor:Colors.black,
                  onPressed: () {},
                  child:  Icon(
                    Icons.cached,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0)
                ),
                RawMaterialButton(
                  fillColor:Colors.black,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage(user: user)));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0)
                ),
                RawMaterialButton(
                  fillColor:Colors.black ,
                  onPressed: () {},
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}