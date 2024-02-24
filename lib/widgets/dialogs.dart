import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodiboom/utils/constants.dart';



  Widget warningDialog(BuildContext context, String title, String firstOption, String secondOption) {
    return CupertinoAlertDialog(
      // title: Text('Cupertino Alert Dialog'),
      content: Text(
        title,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              firstOption,
              style: TextStyle(color: errorColor),
            )),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            secondOption,
            style: TextStyle(color: whiteColor),
          ),
        )
      ],
    );
  }
  