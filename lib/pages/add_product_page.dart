import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';
import 'add_category_page.dart';

class AddProductPage extends StatefulWidget {

  GoogleSignInAccount user;

  AddProductPage({Key key, this.user}) : super(key: key);

  _AddProductPageState createState() => _AddProductPageState(user);
}

class _AddProductPageState extends State<AddProductPage> {
  _AddProductPageState(this.user);
  
  GoogleSignInAccount user;
  Firestore db = Firestore.instance;
   
  String _userDisplayName;
  String _userPhotoUrl;
  

  // Make a "Product" class instead
  
  String _description;
  String _mainCategory = " ";
  String _pref1 = " ";
  String _pref2 = " ";
  String _pref3 = " ";
  String _imageUrl;
  
  File _image;

  static Widget placeholder = Image.network(
    "https://carepharmaceuticals.com.au/wp-content/uploads/sites/19/2018/02/placeholder-600x400.png",
    fit: BoxFit.cover,
  );
  
  List<Widget> pictures = [placeholder];
  bool isPlaceholder = false;
  
	int picCounter = 1; 

  @override
	void initState() {

    _userDisplayName = user.displayName;
    _userPhotoUrl = user.photoUrl;
    
    
		super.initState();
	}

	Future getImage() async {
		var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
		
		setState(() {
      
    

			_image = tempImage;
			pictures.add(Image.file(_image, fit: BoxFit.cover));
		  picCounter = pictures.length;

      // final StorageReference storRef = FirebaseStorage.instance.ref().child('myimage.jpg');
      // final StorageUploadTask uploadTask = storRef.putFile(_image);
      // String imageUrl = storRef.child("myimage.jpg").getDownloadURL();

      uploadImage(_image);
		});
	}

  Future<String> uploadImage(var imageFile) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("${user.id}/photo.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _imageUrl = dowurl.toString();
    return _imageUrl; 
  }

  dynamic _navigateAndChooseCategory(BuildContext context, String label) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategory()),
    );

    switch(label) { 
      case "category": (result != null) ? _mainCategory = result : null;
      break; 
      case "pref1": (result != null) ? _pref1 = result : null;
      break;
      case "pref2": (result != null) ? _pref2 = result : null;
      break;
      case "pref3": (result != null) ? _pref3 = result : null;
      break; 
      default: {}
      break; 
    } 
    print(result);
  }

  bool _submit() {
    db.collection("products").document().setData({
      "category": _mainCategory,
      "description":_description,
      "pref1": _pref1,
      "pref2": _pref2,
      "pref3": _pref3,
      "userID": user.id,
      "imageUrl": _imageUrl
    });

    Navigator.pop(context);
  }

  Widget _categoryButton(){
    if(_mainCategory == null){
      return RaisedButton(
      child: Text(
        "Add Category",
        style: TextStyle(
          letterSpacing: 2.0
        )),
      textColor: Colors.grey.shade600,
      onPressed:(){
        _navigateAndChooseCategory(context, "category");
      },
      color: Colors.grey.shade200,
      splashColor: Colors.grey,
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
    );
    } else {
      return RaisedButton(
        child: Text(
          "Change",
          style: TextStyle(
            letterSpacing: 2.0
          )),
        textColor: Colors.grey.shade600,
        onPressed:(){
          _navigateAndChooseCategory(context, "category");
        },
        color: Colors.grey.shade200,
        splashColor: Colors.grey,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0)
      );
    }
    
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
			body: Column(
			children: <Widget>[
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Container(
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return pictures[index];
                  },
                  itemCount: picCounter,
                  pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      activeColor: Colors.black,
                      activeSize: 5,
                      size: 5
                    )
                  )
                ),
                height: MediaQuery.of(context).size.width/1.1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 15.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Image.network(_userPhotoUrl),  
                          radius: 30.0,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            _userDisplayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),
                          ),
                          Text("Location: 2 kms")
                        ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: RawMaterialButton(
                              onPressed: getImage,
                              child: Icon(Icons.add_a_photo,
                              color: Colors.black,
                              size: 30),
                            ),
                          )    
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _mainCategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                  letterSpacing: 1.0,
                                  fontFamily: "Champ1" 
                                ),
                              ),
                              // Text(
                              //   "Subcategories soon",
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 16.0,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // )
                            ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        _categoryButton()
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                title: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  maxLength: 150,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder( 
                    ),
                    hintText: "Write small description to the item"),
                  style:   TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 16.0), 
                  // Does not work
                  //validator: (value) => value.isEmpty ? "Description can\'t be empty!" : null,
			            //onSaved: (value) => _description = value,
                  onFieldSubmitted: (value) => _description = value,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("$_pref1"),
                    RaisedButton(
                      child: Text("Add Preference"),
                      textColor: Colors.white,
                      onPressed:(){
                        _navigateAndChooseCategory(context, "pref1");
                      },
                      color: Colors.black,
                      splashColor: Colors.grey,
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("$_pref2"),
                    RaisedButton(
                      child: Text("Add Preference"),
                      textColor: Colors.white,
                      onPressed:(){
                        _navigateAndChooseCategory(context, "pref2");
                      },
                      color: Colors.black,
                      splashColor: Colors.grey,
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("$_pref3"),
                    RaisedButton(
                      child: Text("Add Preference"),
                      textColor: Colors.white,
                      onPressed:(){
                        _navigateAndChooseCategory(context, "pref3");
                      },
                      color: Colors.black,
                      splashColor: Colors.grey,
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Add Product"),
                    textColor: Colors.white,
                    onPressed: _submit, 
                    color: Colors.black,
                    splashColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )
        ),
		  ]),
    );
  }
}