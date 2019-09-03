//import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:time_tracker_flutter_course/model/myPKs_jobs.dart' as pks;
//import 'package:flutter/services.dart';
//import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';

final CollectionReference collectionReference = Firestore.instance.collection('activities');
final Firestore firestore = Firestore.instance;
//Stream<QuerySnapshot> _stream;
class JobsPage extends StatelessWidget {
  //const JobsPage({@required this.myfunc});
  //final VoidCallback myfunc;

  /*Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_comment, color: Colors.white),
            onPressed: () => EditJobPage.show(
              context,
              database: Provider.of<Database>(context),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    /*return StreamBuilder<QuerySnapshot>(
        stream: _streamPK_Points,
        builder: (context, snapshot){}*/
    return StreamBuilder<List<Job>>(
      //return StreamBuilder<QuerySnapshot>(
      //stream: _streamJobs,
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          //snapshot: snapshot.data.documents,
          snapshot: snapshot,
          itemBuilder: (context, job) => JobListTile(
            key: Key('job-${job.id}'),
            job: job,
            onTap: () => JobEntriesPage.show(context, job),
          ),
          /*itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            //direction: DismissDirection.endToStart,
            //onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),*/
        );
      },
    );
  }

/* Future<void> ParseSaveJobs() async {
    final pointsSaved = await pks.loadData();
    //setState(() {
    //markers.clear();
    for (final job in pointsSaved.jobs) {
      if (firestore.collection('activites').getDocuments() == null) {
        print('Saving JSON Jobs to Firebase');
        firestore.collection('activites').add({'name': job.name, 'id': job.id});
      }
      //});
    }
  }*/
}
