import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodiboom/utils/constants.dart';



  Widget warningDialog(BuildContext context) {
    return CupertinoAlertDialog(
      // title: Text('Cupertino Alert Dialog'),
      content: Text(
        'Are you sure\nyou want to delete your token?',
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(color: errorColor),
            )),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(color: whiteColor),
          ),
        )
      ],
    );
  }
  