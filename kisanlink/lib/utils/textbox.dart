import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String data;
  const TextBox(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.7),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Text(data),
    );
  }
}
