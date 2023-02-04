import 'package:flutter/material.dart';

export 'package:welldone/core/values/colors.dart';
export 'package:welldone/core/values/typography.dart';

mixin designSystem {
  static const Map<int, EdgeInsets> padding = {
    18: EdgeInsets.all(18.0),
    12: EdgeInsets.all(12.0),
    8: EdgeInsets.all(8.0),
  };
  
  static const Map<int, BorderRadius> borderRadius = {
    16: BorderRadius.all(Radius.circular(16)),
    12: BorderRadius.all(Radius.circular(12)),
    8: BorderRadius.all(Radius.circular(8)),
  };
  
  static const List<BoxShadow> shadow = [
    BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 12,
        color: Color.fromRGBO(191, 205, 211, 0.2)
    ),
    BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 12,
        color: Color.fromRGBO(87, 129, 148, 0.06)
    )
  ];
}