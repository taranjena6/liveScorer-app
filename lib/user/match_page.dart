import 'package:Score_Dekho/user/user_ui.dart';
//import 'package:Score_Dekho/user/usreui.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchPage extends StatefulWidget {
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("Match Fixture"),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Matches").snapshots(),
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
                            return UserUi(
                              selector:
                                  documentSnapshot["match Number"].toString(),
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
                            height: 100.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(documentSnapshot["match Number"]
                                    .toString()),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      documentSnapshot["Team1"],
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'VS',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      documentSnapshot["Team2"],
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
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
      ),
    );
  }
}
