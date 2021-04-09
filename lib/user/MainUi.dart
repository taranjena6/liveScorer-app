//import 'package:Score_Dekho/admin/admin_match_fixture.dart';
import 'package:Score_Dekho/user/user_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainUI extends StatefulWidget {
  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009270),
        centerTitle: true,
        title: Text('Score Dekho'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 220,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  CarouselSlider(
                      items: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/IMG-20210303-WA0001-removebg-preview.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Agroha Warriors.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Gujarati Samaj.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Khandelwal Royals.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Maheshwari Kings.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Parshu Sena.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Yuva Patidar.png'),
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                          height: 200,
                          viewportFraction: 0.8,
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          autoPlay: true))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 10, bottom: 10),
              child: Container(
                height: 100,
                width: 330,
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '3rd Cricket For Unity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Venue: Permit Field, Balasore',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Date: 5 Mar to 7 Mar, 2021',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Matches',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Matches")
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UserUi(
                                  selector: documentSnapshot["match Number"]
                                      .toString(),
                                  team1: documentSnapshot["Team1"].toString(),
                                  team2: documentSnapshot["Team2"].toString(),
                                  team1logo:
                                      documentSnapshot["Team1logo"].toString(),
                                  team2logo:
                                      documentSnapshot["Team2logo"].toString(),
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
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Match No: ${documentSnapshot["match Number"]}'
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 180.0),
                                            child: SizedBox(
                                              width: 60,
                                              height: 25,
                                              child: RaisedButton(
                                                color: documentSnapshot[
                                                            "status"] ==
                                                        true
                                                    ? Colors.red
                                                    : Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  'Live',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                    Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                height: 70,
                width: 335,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: Column(
                    children: [
                      Text(
                        "Developed By: Devang Patel, Taran Jena",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Contact Us : rudanidevang@gmail.com",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
