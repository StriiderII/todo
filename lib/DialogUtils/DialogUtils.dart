import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message,
      {bool isCancelable = false}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 8,
              ),
              Text(message),
            ],
          ),
        );
      },
      barrierDismissible: isCancelable,
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String title ='title',
        String? posActionName,
      VoidCallback? posAction,
      VoidCallback? negAction,
      String? negActionName,
      bool isCancelable = false
      }) {


    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          posAction?.call();
        },
        child: Text(posActionName),
      ));
    }

    if (negActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          negAction?.call();
        },
        child: Text(negActionName),
      ));
    }


    showDialog(context: context,
        barrierDismissible: isCancelable = false ,
        builder: ((context){
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: actions,
          );
    })
    );
  }
}
