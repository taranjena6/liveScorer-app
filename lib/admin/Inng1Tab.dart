import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BowlingTab extends StatefulWidget {
  BowlingTab({this.selector});
  final String selector;
  static String bowlername;
  static String stricker;
  static String nonStricker;
  static int team1Wickets = 0;
  static String strikeBowler;
  static int totalOver1 = 0;
  static int totalballs1 = 0;
  static List<String> overballs = [];
  @override
  _BowlingTabState createState() => _BowlingTabState();
}

class _BowlingTabState extends State<BowlingTab> {
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
    String temp = BowlingTab.stricker;
    BowlingTab.stricker = BowlingTab.nonStricker;
    BowlingTab.nonStricker = temp;
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
                    BowlingTab.strikeBowler = value;
                  },
                ),
              ]),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    BowlingTab.bowlername = BowlingTab.strikeBowler;
                    FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .collection("Inng1Bowler")
                        .doc(BowlingTab.bowlername)
                        .get()
                        .then((DocumentSnapshot value) async {
                      createBowler(BowlingTab.bowlername);
                    });

                    Navigator.pop(context);
                  },
                  child: Text("add")),
              FlatButton(
                  onPressed: () async {
                    BowlingTab.bowlername = BowlingTab.strikeBowler;
                    FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .collection("Inng1Bowler")
                        .doc(BowlingTab.bowlername)
                        .get()
                        .then((DocumentSnapshot value) async {
                      over = value.data()["Over"];
                      runs = value.data()['Runs'];
                      wicket = value.data()["Wicket"];
                      status = value.data()["status"];
                      status = true;
                      await updateBowler(BowlingTab.bowlername);
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
        .collection("Inng1Bowler")
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
        .collection("Inng1Bowler")
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

  // updateTeam2Score(team2score, team2wicket) {
  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

  //   Map<String, dynamic> team2data = {
  //     "Team2Score": team2score,
  //     "Team2Wicket": team2wicket
  //   };
  //   documentReference.update(team2data);
  // }

  createBatsmanData(String playername) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng1Batsman")
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

  updateTeam1Wickets() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> twickets = {"Team1Wicket": BowlingTab.team1Wickets};
    documentReference.update(twickets).whenComplete(() => print("updated"));
  }

  updatePlayerDataFor1() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Matches")
        .doc(widget.selector)
        .collection("Inng1Batsman")
        .doc(BowlingTab.stricker);

    Map<String, dynamic> player = {
      "Name": BowlingTab.stricker,
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

    Map<String, dynamic> tscore = {"Team1Score": localteamscore};
    documentReference.update(tscore).whenComplete(() => print("updated"));
  }

  updateTotalOver1() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> totalOver1 = {"TotalOver1": BowlingTab.totalOver1};

    documentReference.update(totalOver1);
  }

  updateTotalBalls1() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Matches").doc(widget.selector);

    Map<String, dynamic> totalball1 = {"TotalBalls1": BowlingTab.totalballs1};

    documentReference.update(totalball1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
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
                                    BowlingTab.strikeBowler = value;
                                  },
                                ),
                              ]),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    BowlingTab.bowlername =
                                        BowlingTab.strikeBowler;
                                    createBowler(BowlingTab.bowlername);
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
                                    BowlingTab.stricker = value;
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Non Stricker",
                                  ),
                                  onChanged: (String value) {
                                    BowlingTab.nonStricker = value;
                                  },
                                ),
                              ]),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    batsmanName = BowlingTab.stricker;
                                    createBatsmanData(batsmanName);
                                  },
                                  child: Text("stricker")),
                              FlatButton(
                                  onPressed: () {
                                    batsmanName = BowlingTab.nonStricker;
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
                            team2score["Team1Score"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0),
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0),
                          ),
                          Text(
                            team2wicket["Team1Wicket"].toString(),
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
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF55C9A4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Batsman',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(),
                        Text(
                          'Runs',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Balls',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '4s',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '6s',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                //stream builder for batsman
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Matches")
                        .doc(widget.selector)
                        .collection("Inng1Batsman")
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
                                                  BowlingTab.stricker
                                              ? documentSnapshot["Name"] + "*"
                                              : documentSnapshot["Name"] + " ",
                                          style: TextStyle(
                                              color:
                                                  documentSnapshot["status"] ==
                                                          true
                                                      ? Colors.blue[400]
                                                      : Colors.grey[600],
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w500),
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
                                        child: Text(
                                            documentSnapshot["six"].toString()),
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
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
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
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                            localteamscore = value.data()["Team1Score"];
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
                            BowlingTab.team1Wickets =
                                value.data()["Team1Wicket"];
                          });
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                                        BowlingTab.stricker = value;
                                      },
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          batsmanName = BowlingTab.stricker;
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
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
                              localteamscore += 3;
                              await updateTeamScore();
                            });
                          });
                        },
                        child: Text('3'),
                      ),
                      FlatButton(
                        onPressed: () {
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
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
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .get()
                              .then((DocumentSnapshot value) async {
                            localteamscore = value.data()["Team1Score"];
                            localteamscore++;
                            await updateTeamScore();
                          });
                        },
                        child: Text('wide'),
                      ),
                      FlatButton(
                        onPressed: () {
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
                              localteamscore += 6;
                              await updateTeamScore();
                            });
                          });
                        },
                        child: Text('6'),
                      ),
                      FlatButton(
                        onPressed: () {
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
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
                          batsmanName = BowlingTab.stricker;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Batsman")
                              .doc(BowlingTab.stricker)
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
                              localteamscore = value.data()["Team1Score"];
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
                      batsmanName = BowlingTab.stricker;
                      FirebaseFirestore.instance
                          .collection("Matches")
                          .doc(widget.selector)
                          .collection("Inng1Batsman")
                          .doc(BowlingTab.stricker)
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
                          localteamscore = value.data()["Team1Score"];
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
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
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
                        .collection("Inng1Bowler")
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
                                                  BowlingTab.strikeBowler
                                              ? documentSnapshot["Name"] + "*"
                                              : documentSnapshot["Name"] + " ",
                                          style: TextStyle(
                                              color:
                                                  documentSnapshot["status"] ==
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls++;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              balls = 0;
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("0");
                              });
                            } else {
                              over = value.data()["Over"];
                              over++;
                              balls = value.data()["Balls"];
                              balls = 0;
                              status = value.data()["status"];
                              status = false;
                              await updateBowler(BowlingTab.bowlername);
                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();

                                setState(() {
                                  BowlingTab.overballs.clear();
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              runs++;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("1");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);

                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              runs += 2;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("2");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);

                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
                                });
                              });
                              over = 0;
                              status = true;
                              runs = 0;

                              showmyDialog();
                            }
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];

                              runs = value.data()["Runs"];
                              runs++;
                              await updateBowler(BowlingTab.bowlername);
                            }
                          });
                          setState(() {
                            BowlingTab.overballs.add("wd");
                          });
                        },
                        child: Text('Wide'),
                      ),
                      FlatButton(
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              runs += 3;
                              await updateBowler(BowlingTab.bowlername);
                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("3");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);
                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
                                });
                              });
                              over = 0;
                              status = true;
                              runs = 0;

                              showmyDialog();
                            }
                          });
                        },
                        child: Text('3'),
                      ),
                      FlatButton(
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              runs += 4;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("4");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);
                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
                                });
                              });
                              over = 0;
                              status = true;
                              runs = 0;

                              showmyDialog();
                            }
                          });
                        },
                        child: Text('4'),
                      ),
                      FlatButton(
                        minWidth: 10,
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];

                              runs = value.data()["Runs"];
                              runs += 5;
                              await updateBowler(BowlingTab.bowlername);
                            }
                          });
                          setState(() {
                            BowlingTab.overballs.add("Wd4");
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
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];

                              runs = value.data()["Runs"];
                              runs++;
                              await updateBowler(BowlingTab.bowlername);
                            }
                          });
                          setState(() {
                            BowlingTab.overballs.add("Nb");
                          });
                        },
                        child: Text('NoBall'),
                      ),
                      FlatButton(
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              wicket = value.data()["Wicket"];
                              wicket++;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("Wkt");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);
                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
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
                            BowlingTab.team1Wickets =
                                value.data()["Team1Wicket"];
                            BowlingTab.team1Wickets++;
                            await updateTeam1Wickets();
                          });
                        },
                        child: Text('wkt'),
                      ),
                      FlatButton(
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];
                              balls++;
                              runs = value.data()["Runs"];
                              runs += 6;
                              await updateBowler(BowlingTab.bowlername);

                              //totalballs update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1++;
                                await updateTotalBalls1();
                              });
                              BowlingTab.totalballs1 = 0;
                              setState(() {
                                BowlingTab.overballs.add("6");
                              });
                            } else {
                              balls = value.data()["Balls"];
                              balls = 0;
                              over = value.data()["Over"];
                              over++;
                              status = value.data()['status'];
                              status = false;

                              await updateBowler(BowlingTab.bowlername);
                              //total update
                              FirebaseFirestore.instance
                                  .collection("Matches")
                                  .doc(widget.selector)
                                  .get()
                                  .then((DocumentSnapshot value) async {
                                BowlingTab.totalOver1 =
                                    value.data()["TotalOver1"];
                                BowlingTab.totalOver1++;
                                await updateTotalOver1();
                                BowlingTab.totalballs1 =
                                    value.data()["TotalBalls1"];
                                BowlingTab.totalballs1 = 0;
                                await updateTotalBalls1();
                                setState(() {
                                  BowlingTab.overballs.clear();
                                });
                              });
                              over = 0;
                              status = true;
                              runs = 0;

                              showmyDialog();
                            }
                          });
                        },
                        child: Text('6'),
                      ),
                      FlatButton(
                        minWidth: 10,
                        onPressed: () {
                          BowlingTab.bowlername = BowlingTab.strikeBowler;
                          FirebaseFirestore.instance
                              .collection("Matches")
                              .doc(widget.selector)
                              .collection("Inng1Bowler")
                              .doc(BowlingTab.bowlername)
                              .get()
                              .then((DocumentSnapshot value) async {
                            balls = value.data()["Balls"];
                            if (balls < 6) {
                              balls = value.data()["Balls"];

                              runs = value.data()["Runs"];
                              runs += 7;
                              await updateBowler(BowlingTab.bowlername);
                            }
                          });
                          setState(() {
                            BowlingTab.overballs.add("Nb6");
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
    );
  }
}
