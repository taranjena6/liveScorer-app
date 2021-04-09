import 'package:Score_Dekho/admin/newtabs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMatchFixture extends StatefulWidget {
  static String teamlogo1;
  static String teamlogo2;
  // static bool livecheck = true;
  static String url1;
  static String url2;
  static bool status = true;

  @override
  _AdminMatchFixtureState createState() => _AdminMatchFixtureState();
}

class _AdminMatchFixtureState extends State<AdminMatchFixture> {
  int matchNo;
  String team1 = "";
  String team2 = "";
  String result;

  createFixtureData() {
    print("created data");
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(matchNo.toString());

    Map<String, dynamic> teams = {
      "status": true,
      "Result": "Match is On Going",
      "Team1": team1,
      "Team1logo": AdminMatchFixture.url1,
      "Team1Score": 0,
      "Team1Wicket": 0,
      "TotalOver1": 0,
      "TotalBalls1": 0,
      "Team2": team2,
      "Team2logo": AdminMatchFixture.url2,
      "Team2Score": 0,
      "Team2Wicket": 0,
      "match Number": matchNo,
      "TotalOver2": 0,
      "TotalBalls2": 0,
    };
    documentReference
        .set(teams)
        .whenComplete(() => print("$matchNo has added"));
  }

  getImage1() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('${AdminMatchFixture.teamlogo1}.png');
    AdminMatchFixture.url1 = await ref.getDownloadURL();
  }

  getImage2() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('${AdminMatchFixture.teamlogo2}.png');
    AdminMatchFixture.url2 = await ref.getDownloadURL();
  }

  updateTeamslogo() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(matchNo.toString());

    Map<String, dynamic> teamslogo = {
      "Team1logo": AdminMatchFixture.url1,
      "Team2logo": AdminMatchFixture.url2
    };
    documentReference.update(teamslogo);
  }

  updateliveColor() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(matchNo.toString());

    Map<String, dynamic> livestatus = {"status": AdminMatchFixture.status};
    documentReference.update(livestatus);
  }

  updateMessage() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(matchNo.toString());

    Map<String, dynamic> msg = {"Result": result};
    documentReference.update(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Match Fixture"),
        centerTitle: true,
        actions: [
          //icon button for msg
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add message"),
                      content: Container(
                        height: 150.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "write message",
                                ),
                                onChanged: (String value) {
                                  result = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(matchNo.toString())
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                await updateMessage();
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Update message")),
                      ],
                    );
                  });
            },
          ),

          //icon button for adding matches
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Add Teams"),
                      content: Container(
                        height: 150.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Match No",
                                ),
                                onChanged: (String value) {
                                  matchNo = int.parse(value);
                                },
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Team1",
                                ),
                                onChanged: (String value1) {
                                  team1 = value1;
                                  AdminMatchFixture.teamlogo1 = value1;
                                },
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Team2",
                                ),
                                onChanged: (String value2) {
                                  team2 = value2;
                                  AdminMatchFixture.teamlogo2 = value2;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(matchNo.toString())
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                AdminMatchFixture.status =
                                    value.data()["status"];

                                AdminMatchFixture.status = false;
                                await updateliveColor();
                                AdminMatchFixture.status = true;
                              });
                            },
                            child: Text("Change live Status")),
                        FlatButton(
                            onPressed: () async {
                              await createFixtureData();
                              await getImage1();
                              await getImage2();
                              await updateTeamslogo();
                              // createDemoFixtureData();
                              Navigator.pop(context);
                            },
                            child: Text("Add")),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Matches").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NewTabs(
                            selector:
                                documentSnapshot["match Number"].toString(),
                            team1: documentSnapshot["Team1"].toString(),
                            team2: documentSnapshot["Team2"].toString(),
                          );
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2.0,
                                    offset: Offset(0.5, 1.0),
                                    blurRadius: 2.0)
                              ],
                              borderRadius: BorderRadius.circular(10.0)),
                          height: 230.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Match No: ${documentSnapshot["match Number"]}'
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 180.0),
                                      child: SizedBox(
                                        width: 60,
                                        height: 25,
                                        child: RaisedButton(
                                          color:
                                              documentSnapshot["status"] == true
                                                  ? Colors.red
                                                  : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            'Live',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      //use image network
                                      Image.network(
                                        documentSnapshot["Team1logo"],
                                        height: 50,
                                      ),
                                      Text(
                                        documentSnapshot["Team1"],
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        '${documentSnapshot['Team1Score']}/${documentSnapshot['Team1Wicket']}',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Text(
                                          '(${documentSnapshot["TotalOver1"]}.${documentSnapshot["TotalBalls1"]})')
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/images/vs1-removebg-preview.png',
                                    height: 50,
                                  ),
                                  Column(
                                    children: [
                                      //use image network
                                      Image.network(
                                        documentSnapshot["Team2logo"],
                                        height: 50,
                                      ),
                                      Text(
                                        documentSnapshot["Team2"],
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        '${documentSnapshot['Team2Score']}/${documentSnapshot['Team2Wicket']}',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Text(
                                          '(${documentSnapshot["TotalOver2"]}.${documentSnapshot["TotalBalls2"]})')
                                    ],
                                  ),
                                ],
                              ),
                              //text from firebase
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    documentSnapshot["Result"],
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
