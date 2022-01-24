// import 'dart:math';

import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final String? name;
  const ContactTile({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color backgroundColor =
    //     Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return ListTile(
      leading: CircleAvatar(
        // backgroundColor: backgroundColor,
        backgroundColor: Colors.blue,
        child: Text(
          name != null ? name![0] : "",
          style: const TextStyle(
            // color: (backgroundColor.computeLuminance() > 0.5)
            //     ? Colors.black
            //     : Colors.white,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(name ?? ""),
    );
  }
}
