import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(45.0), child: AppBar()),
      body: Center(
        child: Text("Bu sayfa EditPost"),
      ),
    );
  }
}
