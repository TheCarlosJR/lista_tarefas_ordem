
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {

  final String title;
  final String message;
  final String btnLabel1;
  final List<String?>? btnLabels;
  final List<VoidCallback?>? btnCallBacks;


  //método create
  BlurryDialog({
    super.key,
    required this.title,
    required this.message,
    required this.btnLabel1,
    this.btnLabels,
    this.btnCallBacks,
  });


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
    );

    return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 6,
            sigmaY: 6,
        ),
        child:  AlertDialog(
          title: Text(
            title,
            style: textStyle,
          ),
          content: Text(
            message,
            style: textStyle,
          ),
          actions: [
            /*
            TextButton(
              child: Text(btnLabels[i]),
              onPressed: btnCallBacks[i],
            ),
            */
            TextButton(
              child: Text(btnLabel1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}