import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  const ButtonComponent(
      {Key? key, required this.textShown, required this.onTap})
      : super(key: key);

  final String textShown;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.4,
        child: OutlinedButton(
            onPressed: onTap,
            child: Text(textShown,
                style: TextStyle(color: Colors.grey[600], fontSize: 20)),
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    const BorderSide(color: Colors.blue, width: 1.6)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))))));
  }
}
