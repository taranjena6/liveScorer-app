import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Squads extends StatefulWidget {
  Squads({this.selector, this.team1, this.team2});
  final String selector;
  final String team1;
  final String team2;
  @override
  _SquadsState createState() => _SquadsState();
}

class _SquadsState extends State<Squads> {
  String playerName;

  showBoxforteam1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Player"),
            content: Container(
              height: 96.0,
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "player name",
                  ),
                  onChanged: (String value) {
                    playerName = value;
                  },
                ),
              ]),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    addPlayerForTeam1(playerName);
                    Navigator.pop(context);
                  },
                  child: Text("add")),
            ],
          );
        });
  }

  //box2
  showBoxforteam2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Player"),
            content: Container(
              height: 96.0,
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "player name",
                  ),
                  onChanged: (String value) {
                    playerName = value;
                  },
                ),
              ]),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    addPlayerForTeam2(playerName);
                    Navigator.pop(context);
                  },
                  child: Text("add")),
            ],
          );
        });
  }

  addPlayerForTeam1(String playername) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Team1Squad")
        .doc(playername);

    Map<String, dynamic> map1 = {
      "playername": playername,
      "created": FieldValue.serverTimestamp()
    };
    documentReference.set(map1);
  }

  addPlayerForTeam2(String playername) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Team2Squad")
        .doc(playername);

    Map<String, dynamic> map2 = {
      "playername": playername,
      "created": FieldValue.serverTimestamp()
    };
    documentReference.set(map2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                    onPressed: () {
                      showBoxforteam1();
                    },
                    child: Text('Add T1')),
                FlatButton(
                    onPressed: () {
                      showBoxforteam2();
                    },
                    child: Text('Add T2')),
              ],
            ),
            Divider(),
            Text(
              widget.team1,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),

            //streambuilder for team1

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Matches")
                    .doc(widget.selector)
                    .collection("Team1Squad")
                    .orderBy('created', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.documents[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 14.0,
                                backgroundImage:
                                    AssetImage("assets/images/iogo.png"),
                              ),
                              title: Text(
                                documentSnapshot["playername"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            SizedBox(
              height: 20.0,
            ),
            Divider(),
            SizedBox(
              height: 20.0,
            ),

            Text(
              widget.team2,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            //Strembuilder 2
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Matches")
                    .doc(widget.selector)
                    .collection("Team2Squad")
                    .orderBy('created', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.documents[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 14.0,
                                backgroundImage:
                                    AssetImage("assets/images/iogo.png"),
                              ),
                              title: Text(
                                documentSnapshot["playername"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
