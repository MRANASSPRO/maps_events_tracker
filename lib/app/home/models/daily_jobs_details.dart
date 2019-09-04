import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entry_job.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
//import 'package:time_tracker_flutter_course/constants/strings.dart';

/// Temporary model class to store the time tracked and pay for a job
class JobDetails {
  JobDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.PK,
    @required this.start,
    @required this.end,
    //@required this.pay,
  });

  final String name;
  double durationInHours;
  String PK;
  DateTime start = Entry().start;
  DateTime end = Entry().end;
//double pay;
}

/// Groups together all jobs/entries on a given day
class DailyJobsDetails {
  DailyJobsDetails({@required this.date, @required this.jobsDetails});

  final DateTime date;
  final List<JobDetails> jobsDetails;

  /*double get pay => jobsDetails
      .map((jobDuration) => jobDuration.pay)
      .reduce((value, element) => value + element);*/

  double get duration => jobsDetails
      .map((jobDuration) => jobDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<EntryJob>> _entriesByDate(List<EntryJob> entries) {
    Map<DateTime, List<EntryJob>> map = {};
    for (var entryJob in entries) {
      final entryDayStart = DateTime(entryJob.entry.start.year,
          entryJob.entry.start.month, entryJob.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryJob];
      } else {
        map[entryDayStart].add(entryJob);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyJobsDetails> all(List<EntryJob> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyJobsDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byJob = _jobsDetails(entriesByDate);
      list.add(DailyJobsDetails(date: date, jobsDetails: byJob));
    }
    return list.toList();
  }

  /// groups entries by job
  static List<JobDetails> _jobsDetails(List<EntryJob> entries) {
    Map<String, JobDetails> jobDuration = {};
    for (var entryJob in entries) {
      //final pay = entry.durationInHours * entryJob.job.ratePerHour;
      final entry = entryJob.entry;
      if (jobDuration[entry.jobId] == null) {
        jobDuration[entry.jobId] = JobDetails(
            name: entryJob.job.name,
            durationInHours: entry.durationInHours,
            PK: entry.PK,
            start: entry.start,
            end: entry.end
            //pay: pay,
            );
      } else {
        jobDuration[entry.jobId].durationInHours += entry.durationInHours;
        //jobDuration[entry.jobId].pay += pay;
      }
    }
    return jobDuration.values.toList();
  }
}
