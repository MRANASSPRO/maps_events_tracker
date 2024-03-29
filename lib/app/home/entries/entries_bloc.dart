import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker_flutter_course/app/home/models/daily_jobs_details.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entry_job.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EntriesBloc {
  EntriesBloc({@required this.database});

  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryJob>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    /*final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);*/

    return <EntriesListTileModel>[
      EntriesListTileModel(
          leadingText: 'Travaux',
          trailingText: Format.hours(totalDuration),
          headerMiddleText: 'Total: ',
          isBold: true
          //middleText: 'Heures Totales:',
          //middleText: Format.currency(totalPay),
          ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        for (JobDetails jobDetails in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            isHeader: true,
            leadingText: Format.date(dailyJobsDetails.date),
            timeText: Format.startEndTime(jobDetails.start) + ' -- ' +
                Format.startEndTime(jobDetails.end),
            trailingText: Format.dayOfWeek(dailyJobsDetails.date),
            isBold: false,
            //middleText: Format.hours(dailyJobsDetails.duration),
          ),
        for (JobDetails jobDetails in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            isBold: true,
            leadingText: jobDetails.name,
            middleText: jobDetails.PK,
            trailingText: Format.hours(jobDetails.durationInHours),
            //middleText: Format.currency(jobDuration.pay),
          ),
      ]
    ];
  }
}
