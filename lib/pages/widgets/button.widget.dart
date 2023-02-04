import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welldone/core/theme/theme.dart';

class Button extends StatelessWidget {
  const Button({
    required this.buttonName,
    required this.onPressed,
  });
  final String buttonName;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
        borderRadius: designSystem.borderRadius[16]!,
        boxShadow: designSystem.shadow,
        color: colors.accent
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        buttonName,
        style: Theme.of(context).textTheme.button?.copyWith(color: colors.white),
      ),
    ),
    );
  }
}
