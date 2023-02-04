import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.onSelectColor,
    required this.availableColors,
    required this.initialColor,
  });
  final Function onSelectColor;
  final List<Color> availableColors;
  final Color initialColor;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _pickedColor;
  @override
  void initState() {
    _pickedColor = widget.initialColor;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.availableColors.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          final color = widget.availableColors[index];
          return InkWell(
            splashColor: color.withOpacity(0.5),
            borderRadius: designSystem.borderRadius[16]!,
            onTap: () {
              widget.onSelectColor(color);
              setState(() {
                _pickedColor = color;
              });
              },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: designSystem.borderRadius[16]!,
                  color: color
              ),
              child: color == _pickedColor ? const Center(
                child: Icon(Iconsax.tick_circle),
              ) : null,
            ),
          );
        },
      )
    );
  }
}

