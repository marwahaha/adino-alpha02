import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'sold_items_page.dart';
import 'settings_page.dart';
import 'liked_items_page.dart';

class UserPage extends StatefulWidget {
  final GoogleSignInAccount user;
  final GoogleSignIn googleSignIn;

  UserPage({Key key, this.user, this.googleSignIn}) : super(key: key);

  _UserPageState createState() => _UserPageState(googleSignIn);
}

class _UserPageState extends State<UserPage> {

  GoogleSignIn googleSignIn;

  _UserPageState(this.googleSignIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: bodyData(),
    );
  }

  Widget profileHeader() => Container(
    height: MediaQuery.of(context).size.height / 3,
    width: double.infinity,
    child: Column(
      children: <Widget>[
        Expanded( 
          child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  width: 125.0,
                  height: 125.0,
                  decoration: BoxDecoration( 
                    border: Border.all(color: Colors.black, width: 2.0),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.user.photoUrl),
                    )
                  )
                ),
                Text(widget.user.displayName)
              ],
            ),
          
        )
      ],
    )
  );

  Widget imagesCard() => Container(
    height: MediaQuery.of(context).size.height / 6,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your items",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
          ),
          Expanded(
            child: Card(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2016/10/31/18/14/ice-1786311_960_720.jpg"),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget postCard() => Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height / 3,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Post",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2.0,
              child: Image.network(
                "https://cdn.pixabay.com/photo/2018/06/12/01/04/road-3469810_960_720.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget profileButton(String name, Function func) => Column(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 13,
        color: Colors.white,
        child: FlatButton(
          onPressed: (){
            func();
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              child: Text(
                name,
                textAlign: TextAlign.left,
              ),
              padding: EdgeInsets.only(left: 15),
            ) 
          )
        ),
      ),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade100,
      )
    ],
  );

  Widget buttonList() => Column(
    children: <Widget>[
      profileButton("Sold Items", (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SoldItemsPage()));
      }),
      profileButton("Liked Items", (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LikedItemsPage()));
      }),
      profileButton("Settings", (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
      }),
      profileButton("Sign out", _handleSignOut)
    ],
  );
      

  Widget bodyData() => SingleChildScrollView(
    child: Column(
      children: <Widget>[
        profileHeader(),
        imagesCard(),
        SizedBox(height: 20),
        buttonList()
      ],
    ),
  );

  Future<void> _handleSignOut() async {
    googleSignIn.disconnect();
  }
}

