import 'package:flutter/material.dart';
import '../authentication.dart';
import 'market_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

import 'dart:async';
import 'dart:convert' show json;



enum FormMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {

  
  
  static String tag = "login-tag";
  LoginPage({this.auth, this.onSignedIn});

	final BaseAuth auth;
	final VoidCallback onSignedIn;
	final FirebaseAuth _auth = FirebaseAuth.instance;
	final ref = FirebaseDatabase.instance.reference();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount _currentUser;
  Firestore db = Firestore.instance;
  FirebaseUser user;
	final _formKey = new GlobalKey<FormState>();

	String _email;
	String _password;
  String _contactText;

  FormMode _formMode = FormMode.LOGIN;
	bool _isLoading = false;

	@override
  	void initState() {
		_isLoading = false;
		super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
     _googleSignIn.signInSilently();
    _handleSignOut();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((dynamic res){
        db.collection("users").document("${_currentUser.id}").snapshots().listen((dataSnapshot){
          if(dataSnapshot.exists){
            print("USER ALREADY EXIST");
          } else {
            db.collection("users").document("${_currentUser.id}").setData({
              "name": _currentUser.displayName
            });
          }
        }); 
        Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPage(user: _currentUser, googleSignIn: _googleSignIn)));
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  bool _validateAndSave() {
		final form = _formKey.currentState;
		
    if (form.validate()) {
			form.save();
			return true;
		}
		
    return false;
  }
  
  // ## Mayuselater code

	// Widget _showLogo = Hero(
	// 	tag: 'logo',
	// 	child: CircleAvatar(
	// 		backgroundColor: Colors.transparent,
	// 		radius: 48.0,
	// 		child: Image.asset("assets/logo.png")
	// 	)
	// );

	Widget _showEmailInput(){
		return TextFormField(
			keyboardType: TextInputType.emailAddress,
			autofocus: false,
			decoration: InputDecoration(
				hintText: "Email",
				contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
				border: UnderlineInputBorder()
			),
			validator: (value) => value.isEmpty ? "Email can\'t be empty!" : null,
			onSaved: (value) => _email = value,
		);
	} 

	Widget _showPasswordInput() {
		return TextFormField(
			autofocus: false,
			obscureText: true,
			decoration: InputDecoration(
				hintText: "Password",
				contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
				border: UnderlineInputBorder()
			),
			validator: (value) => value.isEmpty ? "Password can\'t be empty!" : null,
			onSaved: (value) => _password = value,
		);
	} 

	Widget _showPrimaryButton() {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 16.0),
			child: Material(
				child: MaterialButton(
					minWidth: 150.0,
					height: 42.0,
					onPressed: _validateAndSubmit,
					color: Colors.black,
					child: _formMode == FormMode.LOGIN
            ? Text('Login',
                style: TextStyle(fontSize: 20.0, color: Colors.white))
            : Text('Create account',
                style: TextStyle(fontSize: 20.0, color: Colors.white))
				)
			)
		);
	} 

	Widget _showSecondaryButton() {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 16.0),
			child: Material(
				child: MaterialButton(
					minWidth: 150.0,
					height: 42.0,
					onPressed: (){
						_formMode == FormMode.LOGIN ? _changeFormToSignUp() : _changeFormToLogin();
					},
					color: Colors.white,
					child:_formMode == FormMode.LOGIN
            ? new Text('Sign Up!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
            : new Text('Log In!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
				)
			)
		);
	} 

  Widget _showGoogleSignInButton() {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
			child: Material(
				child: MaterialButton(
					minWidth: 150.0,
					height: 42.0,
					onPressed: (){
            _handleSignIn();
            print(_currentUser);
          },
					color: Colors.redAccent,
					child: Text(
            'Just Google!',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
				)
			)
		);
	}

  //## Mayusenever code

	// Widget _showErrorMessage() {
	// 	if (_errorMessage.length > 0 && _errorMessage != null) {
	// 	return new Text(
	// 		_errorMessage,
	// 		style: TextStyle(
	// 			fontSize: 13.0,
	// 			color: Colors.red,
	// 			height: 1.0,
	// 			fontWeight: FontWeight.w300),
	// 	);
	// 	} else {
	// 	return new Container(
	// 		height: 0.0,
	// 	);
	// 	}
  // 	}

	// ## Shoulduse code
  
  // void _showVerifyEmailSentDialog() {
	// 	showDialog(
	// 	context: context,
	// 	builder: (BuildContext context) {
	// 		// return object of type Dialog
	// 		return AlertDialog(
	// 		title: new Text("Verify your account"),
	// 		content: new Text("Link to verify account has been sent to your email"),
	// 		actions: <Widget>[
	// 			new FlatButton(
	// 			child: new Text("Dismiss"),
	// 			onPressed: () {
	// 				_changeFormToLogin();
	// 				Navigator.of(context).pop();
	// 			},
	// 			),
	// 		],
	// 		);
	// 	},
	// 	);
  // 	}
	
	Widget _showBody() {
		return Container(
			child: Center(
				child: Form(
					key: _formKey,
					child: ScrollConfiguration(
						behavior: MyBehavior(),
						child: ListView(
							shrinkWrap: true,
							padding: EdgeInsets.only(left: 24.0, right: 24.0),
							children: <Widget> [
								SizedBox(height: 80.0),
								Column(
									children: <Widget>[
										Image.asset("images/logo.png"),
										SizedBox(height: 20.0),
										Text("LOGIN",
											style: TextStyle(
												fontSize: 55.0,
												letterSpacing: 3.0,
											)
										)
									]
								),
								SizedBox(height: 95.0),
								_showEmailInput(),
								SizedBox(height: 8.0),
								_showPasswordInput(),
								SizedBox(height: 24.0),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceEvenly,
									children: <Widget>[
										_showSecondaryButton(),
										_showPrimaryButton()
									],
								),
								SizedBox(height: 8.0),
								_showGoogleSignInButton(),
							]	
						)
					),
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
  		return new Scaffold(
			body: Stack(
				children: <Widget>[
				_showBody(),
				],
			));
	}


	void _changeFormToSignUp() {
 		_formKey.currentState.reset();
 		// _errorMessage = "";
  		
		setState(() { 
			_formMode = FormMode.SIGNUP; 
		});
	}

	void _changeFormToLogin() {
		_formKey.currentState.reset();
		// _errorMessage = "";

		setState(() {
			_formMode = FormMode.LOGIN;
		});
	}

	_validateAndSubmit() async {
		setState(() {
			// _errorMessage = "";
			_isLoading = true;
		});

		if (_validateAndSave()) {
			String userId = "";
			try {
				if (_formMode == FormMode.LOGIN) {
					FirebaseUser user = await widget._auth.signInWithEmailAndPassword(email: _email, password: _password);
					//Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user)));

					print('Signed in: $userId');
				} else {
					FirebaseUser user = await widget._auth.createUserWithEmailAndPassword(email: _email, password: _password);
					//Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user)));
				
					widget.ref.push().set("{\"users\": [" + user.uid + "]}");
					print('Signed up user: $userId');
				}
				if (userId.length > 0 && userId != null) {
					widget.onSignedIn();
				}
			} catch (e) {
				print('Error: $e');
				setState(() {
					_isLoading = false;
					// _errorMessage = e.message;
				});
			}
		}
	}
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
