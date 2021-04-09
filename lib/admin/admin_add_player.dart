//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Inng1Tab.dart';

class AddPlayer extends StatefulWidget {
  static int team1Wickets = 0;
  final String selector;
  AddPlayer({this.selector});
  static String stricker;
  static String nonStricker;
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  int sixes;
  int fours;
  int balls;
  int run;

  String playerName;
  bool out = true;
  int localteamscore = 0;

  swapPlayer() {
    String temp = AddPlayer.stricker;
    AddPlayer.stricker = AddPlayer.nonStricker;
    AddPlayer.nonStricker = temp;
  }

  createPlayerData(String playername) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Players")
        .doc(playername);

    Map<String, dynamic> player = {
      "Name": playername,
      "Runs": 0,
      "Balls": 0,
      "status": true,
      "six": 0,
      "four": 0,
      "created": FieldValue.serverTimestamp()
    };
    documentReference.set(player);
  }

  updatePlayerDataFor1() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Players")
        .doc(AddPlayer.stricker);

    Map<String, dynamic> player = {
      "Name": AddPlayer.stricker,
      "Runs": run,
      "Balls": balls,
      "six": sixes,
      "four": fours,
      "status": out
    };
    documentReference.update(player).whenComplete(() => print("updated"));
  }

  updateTeamScore() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> tscore = {"Team1Score": localteamscore};
    documentReference.update(tscore).whenComplete(() => print("updated"));
  }

  updateTeam1Wickets() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> twickets = {"Team1Wicket": AddPlayer.team1Wickets};
    documentReference.update(twickets).whenComplete(() => print("updated"));
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference fetchTeamData =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[800],
            title: Text("Add Player"),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Batting'),
                ),
                Tab(
                  child: Text('Bowling'),
                )
              ],
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
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
                                    hintText: "Stricker",
                                  ),
                                  onChanged: (String value) {
                                    AddPlayer.stricker = value;
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Non Stricker",
                                  ),
                                  onChanged: (String value) {
                                    AddPlayer.nonStricker = value;
                                  },
                                ),
                              ]),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    playerName = AddPlayer.stricker;
                                    createPlayerData(playerName);
                                  },
                                  child: Text("sticker")),
                              FlatButton(
                                  onPressed: () {
                                    playerName = AddPlayer.nonStricker;
                                    createPlayerData(playerName);
                                    Navigator.pop(context);
                                  },
                                  child: Text(" non sticker"))
                            ],
                          );
                        });
                  })
            ],
          ),
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  //container for score
                  Container(
                    height: 200.0,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Batsman"),
                            Text("Runs"),
                            Text("Balls"),
                            Text("6"),
                            Text("4")
                          ],
                        ),
                        //stream builder
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Players")
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
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 10.0),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  documentSnapshot["Name"] ==
                                                          AddPlayer.stricker
                                                      ? documentSnapshot[
                                                              "Name"] +
                                                          "*"
                                                      : documentSnapshot[
                                                              "Name"] +
                                                          " ",
                                                  style: TextStyle(
                                                      color: documentSnapshot[
                                                                  "status"] ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.black,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              // SizedBox(width: 50.0),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      documentSnapshot["Runs"]
                                                          .toString())),
                                              // SizedBox(width: 40.0),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    documentSnapshot["Balls"]
                                                        .toString()),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    documentSnapshot["six"]
                                                        .toString()),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    documentSnapshot["four"]
                                                        .toString()),
                                              ),
                                            ],
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
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        swapPlayer();
                                      });
                                    },
                                    child: Text("Swap Batsman")),
                                FlatButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Matches")
                                          .doc(widget.selector)
                                          .get()
                                          .then((DocumentSnapshot value) async {
                                        AddPlayer.team1Wickets =
                                            value.data()["Team1Wicket"];
                                        AddPlayer.team1Wickets++;
                                        await updateTeam1Wickets();
                                      });
                                      FirebaseFirestore.instance
                                          .collection("Matches")
                                          .doc(widget.selector)
                                          .collection("Players")
                                          .doc(AddPlayer.stricker)
                                          .get()
                                          .then((DocumentSnapshot value) async {
                                        out = value.data()["status"];
                                        out = false;
                                        balls = value.data()["Balls"];
                                        balls++;
                                        run = value.data()["Runs"];
                                        fours = value.data()["four"];
                                        sixes = value.data()["six"];

                                        await updatePlayerDataFor1();
                                        balls = 0;
                                        run = 0;
                                        fours = 0;
                                        sixes = 0;
                                        out = true;
                                      });
                                      //
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Add Player"),
                                              content: Container(
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: "Stricker",
                                                  ),
                                                  onChanged: (String value) {
                                                    AddPlayer.stricker = value;
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      playerName =
                                                          AddPlayer.stricker;
                                                      createPlayerData(
                                                          playerName);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("sticker")),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text("Out")),
                                FlatButton(
                                  onPressed: () {
                                    fetchTeamData
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      localteamscore =
                                          value.data()["Team1Score"];
                                      localteamscore++;
                                      await updateTeamScore();
                                      // await getTeamScore();
                                    });
                                  },
                                  child: Text("Wide"),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          child: Container(
                              child: Column(
                        children: [
                          Row(
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(balls);
                                      run = value.data()["Runs"];
                                      fours = value.data()["four"];
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      balls = 0;
                                      run = 0;
                                      fours = 0;
                                      sixes = 0;
                                    });
                                  },
                                  child: Text("0")),
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      run = value.data()["Runs"];
                                      run++;
                                      balls = value.data()["Balls"];
                                      balls++;
                                      fours = value.data()["four"];
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      run = 0;
                                      balls = 0;
                                      fours = 0;
                                      sixes = 0;
                                      swapPlayer();
                                      fetchTeamData
                                          .get()
                                          .then((DocumentSnapshot value) async {
                                        localteamscore =
                                            value.data()["Team1Score"];
                                        localteamscore++;
                                        print(localteamscore);
                                        await updateTeamScore();
                                      });
                                    });
                                  },
                                  child: Text("1")),
                            ],
                          ),
                          Row(
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(balls);
                                      run = value.data()["Runs"];
                                      run += 2;
                                      fours = value.data()["four"];
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      balls = 0;
                                      run = 0;
                                      fours = 0;
                                      sixes = 0;
                                    });
                                    fetchTeamData
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      localteamscore =
                                          value.data()["Team1Score"];
                                      localteamscore += 2;
                                      updateTeamScore();
                                    });
                                  },
                                  child: Text("2")),
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      run = value.data()["Runs"];
                                      run += 3;
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(run);
                                      print(balls);
                                      fours = value.data()["four"];
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      run = 0;
                                      balls = 0;
                                      fours = 0;
                                      sixes = 0;
                                      swapPlayer();
                                      fetchTeamData
                                          .get()
                                          .then((DocumentSnapshot value) async {
                                        localteamscore =
                                            value.data()["Team1Score"];
                                        localteamscore += 3;
                                        await updateTeamScore();
                                      });
                                    });
                                  },
                                  child: Text("3")),
                            ],
                          ),
                          Row(
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(balls);
                                      run = value.data()["Runs"];
                                      run += 4;
                                      fours = value.data()["four"];
                                      fours++;
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      balls = 0;
                                      run = 0;
                                      sixes = 0;
                                      fours = 0;
                                    });
                                    fetchTeamData
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      localteamscore =
                                          value.data()["Team1Score"];
                                      localteamscore += 4;
                                      await updateTeamScore();
                                    });
                                  },
                                  child: Text("4")),
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      run = value.data()["Runs"];
                                      run += 5;
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(run);
                                      print(balls);
                                      fours = value.data()["four"];
                                      sixes = value.data()["six"];
                                      await updatePlayerDataFor1();
                                      run = 0;
                                      balls = 0;
                                      fours = 0;
                                      sixes = 0;
                                      swapPlayer();
                                      fetchTeamData
                                          .get()
                                          .then((DocumentSnapshot value) async {
                                        localteamscore =
                                            value.data()["Team1Score"];
                                        localteamscore += 5;
                                        await updateTeamScore();
                                      });
                                    });
                                  },
                                  child: Text("5")),
                            ],
                          ),
                          Row(
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Matches")
                                        .doc(widget.selector)
                                        .collection("Players")
                                        .doc(AddPlayer.stricker)
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      balls = value.data()["Balls"];
                                      balls++;
                                      print(balls);
                                      run = value.data()["Runs"];
                                      run += 6;
                                      sixes = value.data()["six"];
                                      sixes++;
                                      fours = value.data()["four"];
                                      await updatePlayerDataFor1();
                                      balls = 0;
                                      run = 0;
                                      sixes = 0;
                                      fours = 0;
                                    });
                                    fetchTeamData
                                        .get()
                                        .then((DocumentSnapshot value) async {
                                      localteamscore =
                                          value.data()["Team1Score"];
                                      localteamscore += 6;
                                      await updateTeamScore();
                                    });
                                  },
                                  child: Text("6")),
                              //FlatButton(onPressed: () {}, child: Text(".")),
                            ],
                          ),
                        ],
                      )))
                    ],
                  ),
                  Text("Team Score:$localteamscore")
                ],
              ),
            ),

            //second tab i.e bowling tab
            SingleChildScrollView(
              child: BowlingTab(
                selector: widget.selector,
              ),
            )
          ])),
    );
  }
}
