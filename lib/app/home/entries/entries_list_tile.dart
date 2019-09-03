import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntriesListTileModel {
  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.timeText,
    this.isHeader = false,
    this.isBold = false,
  });
  final String leadingText;
  final String trailingText;
  final String middleText;
  final String timeText;
  final bool isHeader;
  final bool isBold;
}

class EntriesListTile extends StatelessWidget {
  const EntriesListTile({@required this.model});
  final EntriesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const fontSize = 18.0;
    //const fontWeight = FontWeight.w600;
    return Container(
      color: model.isHeader ? Colors.indigo[200] : null,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(model.leadingText, style: TextStyle(fontSize: fontSize, fontWeight: model.isBold ? FontWeight.w600 : null)),
          Expanded(child: Container()),
          if (model.middleText != null)
            Text(
              model.middleText,
              style: TextStyle(color: Colors.red[900], fontSize: 16.0),
              textAlign: TextAlign.right,
            ),
          if (model.timeText != null)
            Text(
              model.timeText,
              style: TextStyle(color: Colors.green[800], fontSize: 16.0),
              textAlign: TextAlign.right,
            ),
          SizedBox(
            width: 60.0,
            child: Text(
              model.trailingText,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
