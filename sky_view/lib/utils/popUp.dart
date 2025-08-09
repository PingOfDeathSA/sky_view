         import 'package:flutter/material.dart';
import 'package:sky_view/main.dart';

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error occured'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Back to main page'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
            },
          ),
        ],
      );
    },
  );
}