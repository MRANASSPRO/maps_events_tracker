import 'dart:async';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  Future<void> setJob(Job job);

  //Future<void> deleteJob(Job job);

  Stream<List<Job>> jobsStream();

  Stream<Job> jobStream({@required String jobId});

  Future<void> setEntry(Entry entry);

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream({Job job});

  Stream<List<Entry>> PKs_Stream({Entry entry});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  //static Entry entry;
  //final docId = Firestore.instance.collection('backup_PKs').document(entry.PK).documentID;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        //path: APIPath.job(uid, job.id),
        path: APIPath.job(job.id),
        data: job.toMap(),
      );

  /*@override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    //await _service.deleteData(path: APIPath.job(uid, job.id));
    await _service.deleteData(path: APIPath.job(job.id));
  }*/

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        //path: APIPath.job(uid, jobId),
        path: APIPath.job(jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        //path: APIPath.jobs(uid),
        path: APIPath.jobs(),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        //path: APIPath.entry(uid, entry.id),
        path: APIPath.entry(entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      //await _service.deleteData(path: APIPath.entry(uid, entry.id));
      await _service.deleteData(path: APIPath.entry(entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        //path: APIPath.entries(uid),
        path: APIPath.entries(),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Stream<List<Entry>> PKs_Stream({Entry entry}) =>
      _service.collectionStream<Entry>(
        //path: APIPath.entries(uid),
        path: APIPath.entries(),
        queryBuilder: entry != null
            ? (query) => query.where('PK', isEqualTo: entry.PK)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        //sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
