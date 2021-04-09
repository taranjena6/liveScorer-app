import 'package:Score_Dekho/admin/Inng1Tab.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bowling1Tab extends StatefulWidget {
  Bowling1Tab({this.selector});
  final String selector;
  static String bowlername1;
  static String stricker1;
  static String nonStricker1;
  static int team2Wickets = 0;
  static String strikeBowler;
  static int totalballs2;
  static int totalOver2;
  static List<String> inng2Balls = [];

  @override
  _Bowling1TabState createState() => _Bowling1TabState();
}

class _Bowling1TabState extends State<Bowling1Tab> {
  bool out = true;
  bool status = true;
  int over = 0;
  int runs = 0;
  int wicket = 0;
  int balls = 0;
  String batsmanName;
  int sixes;
  int fours;
  int ball;
  int run;
  int localteamscore;

  swapPlayer() {
    String temp = Bowling1Tab.stricker1;
    Bowling1Tab.stricker1 = Bowling1Tab.nonStricker1;
    Bowling1Tab.nonStricker1 = temp;
  }

  showmyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("select bowler"),
            content: Container(
              height: 96.0,
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "bowler name",
                  ),
                  onChanged: (String value) {
                    Bowling1Tab.strikeBowler = value;
                  },
                ),
              ]),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                    FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .collection("Inng2Bowler")
                        .doc(Bowling1Tab.bowlername1)
                        .get()
                        .then((DocumentSnapshot value) async {
                      createBowler(Bowling1Tab.bowlername1);
                    });

                    Navigator.pop(context);
                  },
                  child: Text("add")),
              FlatButton(
                  onPressed: () async {
                    Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                    FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .collection("Inng2Bowler")
                        .doc(Bowling1Tab.bowlername1)
                        .get()
                        .then((DocumentSnapshot value) async {
                      over = value.data()["Over"];
                      runs = value.data()['Runs'];
                      wicket = value.data()["Wicket"];
                      status = value.data()["status"];
                      status = true;
                      await updateBowler(Bowling1Tab.bowlername1);
                    });

                    Navigator.pop(context);
                  },
                  child: Text("select")),
            ],
          );
        });
  }

  createBowler(String bowler) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng2Bowler")
        .doc(bowler);

    Map<String, dynamic> bowlerdata = {
      "Name": bowler,
      "Over": 0,
      "Runs": 0,
      "Balls": 0,
      "Wicket": 0,
      "status": true
    };
    documentReference.set(bowlerdata);
  }

  updateBowler(bowler) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng2Bowler")
        .doc(bowler);

    Map<String, dynamic> bowlerdata = {
      "Name": bowler,
      "Over": over,
      "Runs": runs,
      "Balls": balls,
      "Wicket": wicket,
      "status": status
    };
    documentReference.update(bowlerdata);
  }

  updateTeam2Score(team2score, team2wicket) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> team2data = {
      "Team2Score": team2score,
      "Team2Wicket": team2wicket
    };
    documentReference.update(team2data);
  }

  createBatsmanData(String playername) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng2Batsman")
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

  updateTeam2Wickets() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> twickets = {"Team2Wicket": Bowling1Tab.team2Wickets};
    documentReference.update(twickets).whenComplete(() => print("updated"));
  }

  updatePlayerDataFor1() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng2Batsman")
        .doc(Bowling1Tab.stricker1);

    Map<String, dynamic> player = {
      "Name": Bowling1Tab.stricker1,
      "Runs": run,
      "Balls": ball,
      "six": sixes,
      "four": fours,
      "status": out
    };
    documentReference.update(player).whenComplete(() => print("updated"));
  }

  updateTeamScore() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> tscore = {"Team2Score": localteamscore};
    documentReference.update(tscore).whenComplete(() => print("updated"));
  }

  updateTotalOver2() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> totalOver1 = {"TotalOver2": Bowling1Tab.totalOver2};

    documentReference.update(totalOver1);
  }

  updateTotalBalls2() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> totalball1 = {"TotalBalls2": Bowling1Tab.totalballs2};

    documentReference.update(totalball1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      //dialog box

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Add bowler"),
                              content: Container(
                                height: 96.0,
                                child: Column(children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "bowler name",
                                    ),
                                    onChanged: (String value) {
                                      Bowling1Tab.strikeBowler = value;
                                    },
                                  ),
                                ]),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Bowling1Tab.bowlername1 =
                                          Bowling1Tab.strikeBowler;
                                      createBowler(Bowling1Tab.bowlername1);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Add")),
                              ],
                            );
                          });
                    },
                    child: Text('Addbowler')),

                //add batsman
                FlatButton(
                    child: Text("Add Batsman"),
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
                                      Bowling1Tab.stricker1 = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Non Stricker",
                                    ),
                                    onChanged: (String value) {
                                      Bowling1Tab.nonStricker1 = value;
                                    },
                                  ),
                                ]),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      batsmanName = Bowling1Tab.stricker1;
                                      createBatsmanData(batsmanName);
                                    },
                                    child: Text("stricker")),
                                FlatButton(
                                    onPressed: () {
                                      batsmanName = Bowling1Tab.nonStricker1;
                                      createBatsmanData(batsmanName);
                                      Navigator.pop(context);
                                    },
                                    child: Text(" non sticker"))
                              ],
                            );
                          });
                    }),

                //Streambuilder

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var team2score = snapshot.data;
                        var team2wicket = snapshot.data;
                        return Row(
                          children: [
                            Text(
                              team2score["Team2Score"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22.0),
                            ),
                            Text(
                              '/',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22.0),
                            ),
                            Text(
                              team2wicket["Team2Wicket"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22.0),
                            )
                          ],
                        );
                      } else {
                        return Text("0");
                      }
                    }),
              ],
            ),
            //Batsman Container
            Container(
              // constraints: BoxConstraints(minHeight: 30.0, maxHeight: 500),
              //height: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Batsman',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(),
                        Text(
                          'Runs',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Balls',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '4s',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '6s',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  //stream builder for batsman
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Matches")
                          .doc(widget.selector)
                          .collection("Inng2Batsman")
                          .orderBy('created', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
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
                                                    Bowling1Tab.stricker1
                                                ? documentSnapshot["Name"] + "*"
                                                : documentSnapshot["Name"] +
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
                                            child: Text(documentSnapshot["Runs"]
                                                .toString())),
                                        // SizedBox(width: 40.0),
                                        Expanded(
                                          flex: 2,
                                          child: Text(documentSnapshot["Balls"]
                                              .toString()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(documentSnapshot["four"]
                                              .toString()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(documentSnapshot["six"]
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
            //bottom conatiner for batsman button
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              swapPlayer();
                            });
                          },
                          child: Text('SwapBatsman'),
                        ),
                        FlatButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              ball = value.data()["Balls"];
                              ball++;
                              print(balls);
                              run = value.data()["Runs"];
                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              ball = 0;
                              run = 0;
                              fours = 0;
                              sixes = 0;
                            });
                          },
                          child: Text('0'),
                        ),
                        FlatButton(
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run++;
                              ball = value.data()["Balls"];
                              ball++;
                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;
                              swapPlayer();
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore++;
                                print(localteamscore);
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('1'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              ball = value.data()["Balls"];
                              ball++;
                              print(balls);
                              run = value.data()["Runs"];
                              run += 2;
                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              ball = 0;
                              run = 0;
                              fours = 0;
                              sixes = 0;
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) async {
                              localteamscore = value.data()["Team2Score"];
                              localteamscore += 2;
                              updateTeamScore();
                            });
                          },
                          child: Text('2'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) async {
                              Bowling1Tab.team2Wickets =
                                  value.data()["Team2Wicket"];
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              out = value.data()["status"];
                              out = false;
                              ball = value.data()["Balls"];
                              ball++;
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
                                          Bowling1Tab.stricker1 = value;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            batsmanName = Bowling1Tab.stricker1;
                                            createBatsmanData(batsmanName);
                                            Navigator.pop(context);
                                          },
                                          child: Text("sticker")),
                                    ],
                                  );
                                });
                          },
                          child: Text('out'),
                        ),
                        FlatButton(
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run += 3;
                              ball = value.data()["Balls"];
                              ball++;

                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;
                              swapPlayer();
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 3;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('3'),
                        ),
                        FlatButton(
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run += 4;
                              ball = value.data()["Balls"];
                              ball++;

                              fours = value.data()["four"];
                              fours++;
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;

                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 4;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('4'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run += 4;
                              ball = value.data()["Balls"];

                              fours = value.data()["four"];
                              fours++;
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;

                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 5;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('nb 4'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) async {
                              localteamscore = value.data()["Team2Score"];
                              localteamscore++;
                              await updateTeamScore();
                            });
                          },
                          child: Text('wide'),
                        ),
                        FlatButton(
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run += 6;
                              ball = value.data()["Balls"];
                              ball++;

                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              sixes++;
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;

                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 6;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('6'),
                        ),
                        FlatButton(
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];
                              run += 6;
                              ball = value.data()["Balls"];

                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              sixes++;
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;

                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 7;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('nb 6'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            batsmanName = Bowling1Tab.stricker1;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Batsman")
                                .doc(Bowling1Tab.stricker1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              run = value.data()["Runs"];

                              ball = value.data()["Balls"];

                              fours = value.data()["four"];
                              sixes = value.data()["six"];
                              await updatePlayerDataFor1();
                              run = 0;
                              ball = 0;
                              fours = 0;
                              sixes = 0;

                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                localteamscore = value.data()["Team2Score"];
                                localteamscore += 5;
                                await updateTeamScore();
                              });
                            });
                          },
                          child: Text('wd 5'),
                        ),
                      ],
                    ),
                    FlatButton(
                      onPressed: () {
                        batsmanName = Bowling1Tab.stricker1;
                        FirebaseFirestore.instance
                            .collection("Matches")
                            .doc(widget.selector)
                            .collection("Inng2Batsman")
                            .doc(Bowling1Tab.stricker1)
                            .get()
                            .then((DocumentSnapshot value) async {
                          run = value.data()["Runs"];

                          ball = value.data()["Balls"];

                          fours = value.data()["four"];
                          sixes = value.data()["six"];
                          await updatePlayerDataFor1();
                          run = 0;
                          ball = 0;
                          fours = 0;
                          sixes = 0;
                          swapPlayer();
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .get()
                              .then((DocumentSnapshot value) async {
                            localteamscore = value.data()["Team2Score"];
                            localteamscore++;

                            await updateTeamScore();
                          });
                        });
                      },
                      child: Text('No ball'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            //Bowler Container
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Bowler',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(),
                        Text(
                          'Over',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Runs',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Wicket',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  //stream builder
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Matches")
                          .doc(widget.selector)
                          .collection("Inng2Bowler")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: ScrollPhysics(),
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
                                                    Bowling1Tab.strikeBowler
                                                ? documentSnapshot["Name"] + "*"
                                                : documentSnapshot["Name"] +
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
                                                '${documentSnapshot["Over"]}.${documentSnapshot["Balls"]}'
                                                    .toString())),
                                        // SizedBox(width: 40.0),
                                        Expanded(
                                          flex: 2,
                                          child: Text(documentSnapshot["Runs"]
                                              .toString()),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(documentSnapshot["Wicket"]
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

            //Button container for bowler
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {},
                          child: Text('SwapBowler'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls++;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                balls = 0;
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("0");
                                });
                                balls = 0;
                              } else {
                                over = value.data()["Over"];
                                over++;
                                balls = value.data()["Balls"];
                                balls = 0;
                                status = value.data()["status"];
                                status = false;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();

                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                showmyDialog();
                              }
                            });
                          },
                          child: Text('0'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                runs++;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("1");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;
                                showmyDialog();
                              }
                            });
                          },
                          child: Text('1'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                runs += 2;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("2");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;

                                showmyDialog();
                              }
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) {
                                var team2score = value.data()["Team2Score"];

                                var team2wicket = value.data()["Team2Wicket"];

                                updateTeam2Score(team2score, team2wicket);
                              });
                            });
                          },
                          child: Text('2'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];

                                runs = value.data()["Runs"];
                                runs++;
                                await updateBowler(Bowling1Tab.bowlername1);
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                            setState(() {
                              Bowling1Tab.inng2Balls.add("wd");
                            });
                          },
                          child: Text('Wide'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                runs += 3;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("3");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;

                                showmyDialog();
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                          },
                          child: Text('3'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                runs += 4;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("4");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;

                                showmyDialog();
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                          },
                          child: Text('4'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];

                                runs = value.data()["Runs"];
                                runs += 5;
                                await updateBowler(Bowling1Tab.bowlername1);
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                            setState(() {
                              Bowling1Tab.inng2Balls.add("Wd4");
                            });
                          },
                          child: Text('5'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];

                                runs = value.data()["Runs"];
                                runs++;
                                await updateBowler(Bowling1Tab.bowlername1);
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];
                              team2score += 1;
                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                            setState(() {
                              Bowling1Tab.inng2Balls.add("Nb");
                            });
                          },
                          child: Text('NoBall'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                wicket = value.data()["Wicket"];
                                wicket++;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                Bowling1Tab.totalballs2 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("Wkt");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;
                                wicket = 0;

                                showmyDialog();
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) async {
                              // var team2score = value.data()["Team2Score"];
                              // var team2wicket = value.data()["Team2Wicket"];
                              Bowling1Tab.team2Wickets =
                                  value.data()["Team2Wicket"];
                              Bowling1Tab.team2Wickets++;
                              await updateTeam2Wickets();
                              // updateTeam2Score(team2score, team2wicket);
                            });
                          },
                          child: Text('wkt'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];
                                balls++;
                                runs = value.data()["Runs"];
                                runs += 6;
                                await updateBowler(Bowling1Tab.bowlername1);
                                //totalballs update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2++;
                                  await updateTotalBalls2();
                                });
                                BowlingTab.totalballs1 = 0;
                                setState(() {
                                  Bowling1Tab.inng2Balls.add("6");
                                });
                              } else {
                                balls = value.data()["Balls"];
                                balls = 0;
                                over = value.data()["Over"];
                                over++;
                                status = value.data()['status'];
                                status = false;

                                await updateBowler(Bowling1Tab.bowlername1);
                                //total update
                                FirebaseFirestore.instance
                                    .collection("Matches")
                                    .doc(widget.selector)
                                    .get()
                                    .then((DocumentSnapshot value) async {
                                  Bowling1Tab.totalOver2 =
                                      value.data()["TotalOver2"];
                                  Bowling1Tab.totalOver2++;
                                  await updateTotalOver2();
                                  Bowling1Tab.totalballs2 =
                                      value.data()["TotalBalls2"];
                                  Bowling1Tab.totalballs2 = 0;
                                  await updateTotalBalls2();
                                  setState(() {
                                    Bowling1Tab.inng2Balls.clear();
                                  });
                                });
                                over = 0;
                                status = true;
                                runs = 0;

                                showmyDialog();
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                          },
                          child: Text('6'),
                        ),
                        FlatButton(
                          minWidth: 10,
                          onPressed: () {
                            Bowling1Tab.bowlername1 = Bowling1Tab.strikeBowler;
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .collection("Inng2Bowler")
                                .doc(Bowling1Tab.bowlername1)
                                .get()
                                .then((DocumentSnapshot value) async {
                              balls = value.data()["Balls"];
                              if (balls < 6) {
                                balls = value.data()["Balls"];

                                runs = value.data()["Runs"];
                                runs += 7;
                                await updateBowler(Bowling1Tab.bowlername1);
                              }
                            });
                            FirebaseFirestore.instance
                                .collection("Matches")
                                .doc(widget.selector)
                                .get()
                                .then((DocumentSnapshot value) {
                              var team2score = value.data()["Team2Score"];

                              var team2wicket = value.data()["Team2Wicket"];

                              updateTeam2Score(team2score, team2wicket);
                            });
                            setState(() {
                              Bowling1Tab.inng2Balls.add("Nb6");
                            });
                          },
                          child: Text('7'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
