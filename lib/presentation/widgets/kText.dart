import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  final String _string;
  final double? fontSize;
  final FontWeight? fontWeight;

  const KText(this._string, {Key? key, this.fontSize, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_string,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontSize: fontSize, fontWeight: fontWeight));
  }
}
