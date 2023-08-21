import 'package:flutter/material.dart';
import 'package:management/common/utils/constants.dart';

import 'tiles.dart';

class CustomExpansion extends StatelessWidget {
  final String text1;

  final String text2;

  final void Function(bool)? onExpansionChanged;

  final Widget? trailing;

  final List<Widget> children;

  const CustomExpansion(
      {super.key,
      required this.text1,
      required this.text2,
      this.onExpansionChanged,
      this.trailing,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.all(
            Radius.circular(AppConst.kRadius),
          ),
        ),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            unselectedWidgetColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: BottomTiles(
              text1: text1,
              text2: text2,
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: onExpansionChanged,
            controlAffinity: ListTileControlAffinity.trailing,
            trailing: trailing,
            children: children,
          ),
        ));
  }
}
