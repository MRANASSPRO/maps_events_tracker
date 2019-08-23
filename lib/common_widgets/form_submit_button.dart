import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
    key: key,
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    height: 44.0,
    color: Colors.indigo,
    textColor: Colors.black87,
    borderRadius: 4.0,
    loading: loading,
    onPressed: onPressed,
  );
}


/*class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}*/
