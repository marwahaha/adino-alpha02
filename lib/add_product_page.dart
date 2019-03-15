import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'add_category_page.dart';
//import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  final Widget child;
  GoogleSignInAccount user;

  AddProductPage({Key key, this.child, this.user}) : super(key: key);

  _AddProductPageState createState() => _AddProductPageState(user);
}

class _AddProductPageState extends State<AddProductPage> {
  _AddProductPageState(this.user);
  
  GoogleSignInAccount user;
  String _userDisplayName;
  String _userPhotoUrl;

  String _mainCategory = " ";
  List<String> _prefCategories;
  
  File _image;
  List<Widget> pictures = [];
	int iCount = 0;

  List _cities = ["Dress", "Watch", "Shoes", "Belt", "Other", "Shoes", "Belt", "Shoes", "Belt", "Shoes", "Belt"];
	List<DropdownMenuItem<String>> _dropDownMenuItems;
	String _currentCity;

  //Add Product Form related variables 

  final _formKey = new GlobalKey<FormState>();
  String _description;

  @override
	void initState() {
		_dropDownMenuItems = getDropDownMenuItems();
		_currentCity = _dropDownMenuItems[0].value;
    _userDisplayName = user.displayName;
    _userPhotoUrl = user.photoUrl;
    
		super.initState();
	}

	Future getImage() async {
		var image = await ImagePicker.pickImage(source: ImageSource.gallery);
		
		setState(() {
			_image = image;
			pictures.add(Image.file(image, fit: BoxFit.cover));
		  iCount = pictures.length;
		});
	}

	List<DropdownMenuItem<String>> getDropDownMenuItems() {
		List<DropdownMenuItem<String>> items = List();
		
    for (String city in _cities) {
      items.add(DropdownMenuItem(
        value: city,
        child: Text(city)
      ));
		}

		return items;
	}

	void changedDropDownItem(String selectedCity) {
		setState(() {
		  _currentCity = selectedCity;
		});
	}

  dynamic _navigateAndChooseCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategory()),
    );
    (result != null) ? _mainCategory = result : null;
    
    print(result);
  }

  bool _validateAndSave() {
		// final form = _formKey.currentState;
		
    // if (form.validate()) {
		// 	form.save();
    //   print(_description);
		// 	return true;
		// }
		
    // return false;

    print(_description);

   
  }

  

  Widget dropDown(){
    return DropdownButton(
      value: _currentCity,
      items: _dropDownMenuItems,
      onChanged: changedDropDownItem,
    ); 
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
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
                  itemCount: iCount,
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
                              Text(
                                "Night Out",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        RaisedButton(
                          child: Text("Add Category"),
                          textColor: Colors.white,
                          onPressed:(){
                            _navigateAndChooseCategory(context);
                          },
                          color: Colors.black,
                          splashColor: Colors.grey,
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        )
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
                  validator: (value) => value.isEmpty ? "Description can\'t be empty!" : null,
			            onSaved: (value) => _description = value,
                  onFieldSubmitted: (value) => _description = value,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("Option 1"),
                    Container(
                      child: dropDown(),
                      decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black),
                    ),
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0)	
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("Option 2"),
                    Container(
                      child: DropdownButton(
                        value: _currentCity,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black)
                      ),
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0)	
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text("Option 3"),
                    Container(
                      child: DropdownButton(
                        value: _currentCity,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                      ),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black)
                      ),
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0)	 
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
                    onPressed: _validateAndSave, 
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