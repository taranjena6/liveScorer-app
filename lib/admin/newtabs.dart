import 'package:Score_Dekho/admin/Inng2Tab.dart';
import 'package:Score_Dekho/admin/squads.dart';
import 'package:flutter/material.dart';

import 'Inng1Tab.dart';

class NewTabs extends StatefulWidget {
  NewTabs({this.selector, this.team1, this.team2});
  final String selector;
  final String team1;
  final String team2;
  @override
  _NewTabsState createState() => _NewTabsState();
}

class _NewTabsState extends State<NewTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF009270),
            centerTitle: true,
            title: Text('Match ${widget.selector}'),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text('Squads'),
                ),
                Tab(
                  child: Text('Ing 1'),
                ),
                Tab(
                  child: Text('Ing 2'),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            //Squads tab1
            Squads(
                selector: widget.selector,
                team1: widget.team1,
                team2: widget.team2),
            //Ing1 tab2
            SingleChildScrollView(
              child: BowlingTab(
                selector: widget.selector,
              ),
            ),
            //Ing2 tab3
            Bowling1Tab(
              selector: widget.selector,
            )
          ]),
        ));
  }
}
