import "package:flutter/material.dart";
import '../utils/cards_section_draggable.dart';
import 'add_product_page.dart';
import 'user_page.dart';
import '../utils/tab_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MarketPage extends StatefulWidget {
  final Widget child;
  GoogleSignInAccount user;
  GoogleSignIn googleSignIn;
  
  MarketPage({Key key, this.child, this.user, this.googleSignIn}) : super(key: key);

  _MarketPageState createState() => _MarketPageState(user, googleSignIn);
}

class _MarketPageState extends State<MarketPage> {

  Firestore db = Firestore.instance;
  _MarketPageState(this.user, this.googleSignIn){
    print(googleSignIn);
  }
  GoogleSignInAccount user;
  GoogleSignIn googleSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Builder(
          builder: (context) => Column(
          children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(user: user, googleSignIn: googleSignIn)));
                  },
                  child:  Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  shape:  CircleBorder(),
                  padding: const EdgeInsets.all(0.0),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DTabController()));
                  },
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
          Container(
            
            height: 35.0,
            width: double.infinity,
            color: Colors.white,
            child: RawMaterialButton(
              child: Text("FILTER", style: TextStyle(fontSize: 10,color: Colors.black)),
              onPressed: (){},
            ),
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
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Item added to your favourites!"),
                        action: SnackBarAction(
                          label: 'Fuck yeaeh',
                          onPressed: () {
                            Scaffold.of(context).removeCurrentSnackBar();
                          }
                        )
                      )
                    );
                  },
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
    )
    );
  }
}