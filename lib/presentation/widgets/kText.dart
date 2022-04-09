import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  final String _string;
  const KText(this._string,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_string);
  }
}
