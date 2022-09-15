import 'package:flutter/material.dart';

class SubstringHighlight extends StatelessWidget {
  const SubstringHighlight({
    Key? key,
    required this.text,
    required this.terms,
    this.textStyle = const TextStyle(color: Colors.black),
    this.textStyleHighlight = const TextStyle(color: Colors.red),
  }) : super(key: key);

  final String text;
  final List<String> terms;
  final TextStyle textStyle;
  final TextStyle textStyleHighlight;

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) {
      return Text(
        text,
        style: textStyle,
      );
    } else {
      final matchingTerms = terms
          .where((element) => text.toLowerCase().contains(element))
          .toList();
      if (matchingTerms.isEmpty) {
        return Text(text, style: textStyle);
      }

      final termMatch = matchingTerms.first;
      final termLC = termMatch.toLowerCase();

      final List<InlineSpan> children = [];
      final List<String> spanList = text.toLowerCase().split(termLC);
      int i = 0;
      spanList.forEach((element) {
        if (element.isNotEmpty) {
          children.add(
            TextSpan(
              text: text.substring(i, i + element.length),
              style: textStyle,
            ),
          );
        }

        if (i < text.length) {
          children.add(
            TextSpan(
              text: text.substring(i, i + termMatch.length),
              style: textStyleHighlight,
            ),
          );
          i += termMatch.length;
        }
      });

      return RichText(text: TextSpan(children: children));
    }
  }
}
