import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.jobId,
    this.jobName,
    @required this.start,
    @required this.end,
    @required this.PK,
    //this.comment,
  });

  String id;
  String jobId;
  String jobName;
  DateTime start;
  DateTime end;
  String PK;
  //String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Entry(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      PK: value['PK'],
      //comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'PK': PK,
      //'comment': comment,
    };
  }
}
