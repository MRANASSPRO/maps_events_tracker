import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/maps/maps_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:time_tracker_flutter_course/model/myPKs_jobs.dart' as pks;
//import 'package:time_tracker_flutter_course/app/home/maps/store_map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //_streamJobs = Firestore.instance.collection('activities').orderBy('id').snapshots();
  //Stream<QuerySnapshot> _streamJobs;
  Firestore firestore = Firestore.instance;
  TabItem _currentTab = TabItem.jobs;

  @override
  void initState() {
    super.initState();
    //StoreMap().getCreateMarkers();
    //_streamJobs = Firestore.instance.collection('activities').orderBy('id').snapshots();
    //getJobs();
  }

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
    TabItem.maps: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
      TabItem.maps: (_) => MapsPage(),
    };
  }

  void _select(TabItem tabItem) {
    //getJobs();
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

  /*Future<void> parseSaveJobs() async {
    final pointsSaved = await pks.loadData();
    setState(() {
      //markers.clear();
      for (final job in pointsSaved.jobs) {
        if (firestore.collection('activites').snapshots().length.toString() !=
            '0') {
          //if (firestore.collection('activites').getDocuments() != null) {
          print('Saving JSON Jobs to Firebase');
          firestore
              .collection('activites')
              .add({'name': job.name, 'id': job.id});
        }
        //final marker = Marker(
        /*Marker(
          markerId: MarkerId(pk.name),
          position: LatLng(pk.location.lat, pk.location.lng),
          infoWindow: InfoWindow(
            title: pk.name,
            snippet: pk.address,
          ),
        );*/
        //markers.add(marker);
      }
    });
  }*/
}
