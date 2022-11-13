import 'package:flutter/material.dart';

class TransparentAppBar extends AppBar {
  BuildContext ctx;
  String text;

  TransparentAppBar(this.text, this.ctx, {Key? key}) : super(key: key);

  Widget build(ctx) {
    return AppBar(
      title: Text(text),
      titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 25),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 30, color: Colors.blue)),
    );
  }
}
