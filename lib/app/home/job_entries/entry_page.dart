import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/common_widgets/date_time_picker.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'package:time_tracker_flutter_course/model/myPKs_jobs.dart' as pks;
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({@required this.database, @required this.job, this.entry});

  final Job job;
  final Entry entry;
  final Database database;

  static Future<void> show(
      {BuildContext context, Database database, Job job, Entry entry}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, job: job, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  //final _streamJobs = Firestore.instance.collection('entries').orderBy('id').snapshots();
  List<String> PKs_list = [];
  List<DropdownMenuItem<pks.Pk>> items;
  DropdownButton<String> PKs_Point;

  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _selected_PK;

  //String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);
    _selected_PK = widget.entry?.PK;
    //_comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      PK: _selected_PK,
      //comment: _comment,
    );
  }

  Future<List<String>> pksToList() async {
    if (PKs_list.length < 1) {
      final pointsSaved = await pks.loadData();
      setState(() {
        for (final pk in pointsSaved.pks) {
          PKs_list.add(pk.name);
        }
      });
      return PKs_list;
    } else
      return PKs_list;
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      //SnackBar(content: new Text(" Travail modifié!"));
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    pksToList();
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: AutoSizeText(widget.job.name),
        actions: <Widget>[
          FlatButton(
            child: AutoSizeText(
              widget.entry != null ? 'Modifier' : 'Ajouter',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              SizedBox(height: 8.0),
              _buildDuration(),
              SizedBox(height: 16.0),
              _setDropDown(),
              //_buildDropDown(),
              //_buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Début',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'Fin',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AutoSizeText(
          'Durée: $durationFormatted',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _setDropDown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              labelText: 'Choisir PK',
              labelStyle:
                  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: _selected_PK == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selected_PK,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _selected_PK = newValue;
                  state.didChange(newValue);
                });
              },
              items: PKs_list.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /*Widget _buildDropDown() {
    return DropdownButton(
        items: PKs_list.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
              style: TextStyle(),
            ),
          );
        }).toList(),
        hint: Text('PK'),
        value: _selected_PK,
        onChanged: (value) {
          setState(() {
            _selected_PK = value;
          });
        });
  }*/

/*Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}*/

}
