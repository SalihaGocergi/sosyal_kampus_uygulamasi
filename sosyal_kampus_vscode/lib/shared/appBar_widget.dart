import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  AppBarWidget({
    Key key,
    @required this.title,
  }) : super(key: key);
  var title;
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
        title: Text("$title"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
            ),
          ),
        ),
      ),
    );
  }
}

/*
gradient: RadialGradient(
            radius: 5,
            colors: <Color>[
              Color(int.parse("0xa40000")),
              Color(int.parse("0XFFffa500"))
            ],
          ),
*/
