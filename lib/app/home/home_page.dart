import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/maps/maps_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_flutter_course/model/myPKs_jobs.dart' as pks;
//import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
//import 'package:time_tracker_flutter_course/services/api_path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Stream<QuerySnapshot> _streamJobs;
  //Firestore firestore = Firestore.instance;
  TabItem _currentTab = TabItem.jobs;

  @override
  void initState() {
    super.initState();
    //jsonToFirestore();
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

  Future<void> jsonToFirestore() async {
    final pointsSaved = await pks.loadData();
    setState(() {
      for (final pk in pointsSaved.pks) {
          print('JSON to Firestore');
          firestore.collection('pks_travaux').add({
            'address': pk.address,
            'location': GeoPoint(
              pk.location.lat,
              pk.location.lng,
            ),
            'name': pk.name,
            'id': pk.id,
            'jobType': pk.jobType,
            'debut': pk.debut,
            'fin': pk.fin,
            //'debut': Format.startEndTime(pk.debut),
            //'fin': Format.startEndTime(pk.fin),
          });
      }
    });
  }

/*Future<void> jsonToFirestore() async {
    final pointsSaved = await pks.loadData();
    setState(() {
      for (final job in pointsSaved.jobs) {
        //if (firestore.collection('activites').snapshots().length.toString() != '0') {
        //if (firestore.collection('activites').getDocuments() != null) {
        print('JSON to firestore');
        firestore
            .collection('pks_travaux')
            .add({'name': job.name, 'id': job.id});
        //}
      }
    });
  }*/
}
