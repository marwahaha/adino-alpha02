import 'package:flutter/material.dart';
import 'profile_card_draggable.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class CardsSectionDraggable extends StatefulWidget{
  @override
  _CardsSectionState createState() =>  _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionDraggable>
{
  bool dragOverTarget = false;
 
  List<ProfileCardDraggable> cards =  List();
  int cardsCounter = 0;
  int showCounter = 0;
  String category;
  String description;
  String imageUrl;

  _CardsSectionState(){
    
  }

  @override
  void initState(){
    super.initState();

    for (cardsCounter = 0; cardsCounter <= 1; cardsCounter++){
      cards.add(ProfileCardDraggable(cardsCounter, "a", "b", null));
    }
    print(cardsCounter);

    Firestore.instance
    .collection('products')
    .snapshots()
    .listen((data) =>
      data.documents.forEach((doc){
        print(doc["category"] + " " + doc["description"]);
        category = doc["category"];
        description = doc["description"];
        imageUrl = doc["imageUrl"];
        cards.add(ProfileCardDraggable(cardsCounter, category, description, imageUrl));
        cardsCounter++;
        print("HERE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: " + cardsCounter.toString());
      })
    );
  }

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Stack(
        children: <Widget>[
          // Drag target row
          Row( 
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              dragTarget(),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.grey.shade200,
                )
              ),
              dragTarget()
            ],
          ),
          Align(
            child:  IgnorePointer(child:  SizedBox.fromSize(
              size:  Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.75),
              child: cards[((showCounter + 1) < cardsCounter?(showCounter+1):showCounter)],
            )),
          ),
          // Front card
          Align(
            //alignment:  Alignment(0.0, 0.0),
            child:  Draggable(
              feedback:  SizedBox.fromSize(
                size:  Size(MediaQuery.of(context).size.width * 1, MediaQuery.of(context).size.height * 0.8),
                child: cards[showCounter],
              ),
              child:  SizedBox.fromSize(
                size:  Size(MediaQuery.of(context).size.width * 1, MediaQuery.of(context).size.height * 0.8),
                child: cards[showCounter],
              ),
              childWhenDragging:  Container(),
            ),
          ),
        ],
      )
    );
  }

  void changeCardsOrder(){
    setState((){
      if(showCounter < cardsCounter - 1){
        
        ++showCounter;
        print(showCounter.toString() + " showCounter");
      } else return;
    });
  }

  Widget dragTarget(){
    return  Flexible(
      flex: 1,
      child:  DragTarget(
        builder: (_, __, ___){
          return  Container(color: Colors.grey.shade200,);
        },
        onWillAccept: (_){
          setState(() => dragOverTarget = true);
          return true;
        },
        onAccept: (_){
          changeCardsOrder();
          print(cardsCounter.toString() + " cards counter");
          setState(() => dragOverTarget = false);
        },
        onLeave: (_) => setState(() => dragOverTarget = false)
      ),
    );
  }
}