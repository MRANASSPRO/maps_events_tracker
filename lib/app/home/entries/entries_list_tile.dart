import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntriesListTileModel {
  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.timeText,
    this.headerMiddleText,
    this.isHeader = false,
    this.isBold = false,
  });
  final String leadingText;
  final String trailingText;
  final String middleText;
  final String timeText;
  final String headerMiddleText;
  final bool isHeader;
  final bool isBold;
}

class EntriesListTile extends StatelessWidget {
  const EntriesListTile({@required this.model});
  final EntriesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const bigFontSize = 18.0;
    const smallFontSize = 15.0;
    const mediumFontSize = 16.5;

    const boldFontWeight = FontWeight.w600;
    return Container(
      color: model.isHeader ? Colors.indigo[200] : null,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Row(
        children: <Widget>[
          Text(model.leadingText, style: TextStyle(fontSize: bigFontSize, fontWeight: model.isBold ? boldFontWeight: null)),
          Expanded(child: Container()),
          if (model.middleText != null)
            Text(
              model.middleText,
              style: TextStyle(color: Colors.red[900], fontSize: mediumFontSize),
              textAlign: TextAlign.right,
            ),
          if (model.timeText != null)
            Text(
              model.timeText,
              style: TextStyle(color: Colors.teal[800], fontSize: smallFontSize),
              textAlign: TextAlign.right,
            ),
          if (model.headerMiddleText != null)
            Text(
              model.headerMiddleText,
              style: TextStyle(fontSize: bigFontSize, fontWeight: boldFontWeight),
              textAlign: TextAlign.right,
            ),
          SizedBox(
            width: 60.0,
            child: Text(
              model.trailingText,
              style: TextStyle(fontSize: bigFontSize, fontWeight: model.isBold ? boldFontWeight: null),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
