import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';

class IconPicker extends StatefulWidget {
  const IconPicker({
    super.key,
    required this.onSelectIcon,
    required this.availableIcons,
    required this.initialIcon,
  });
  final Function onSelectIcon;
  final List<IconData> availableIcons;
  final IconData initialIcon;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late IconData _pickedIcon;
  @override
  void initState() {
    _pickedIcon = widget.initialIcon;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.availableIcons.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          final icon = widget.availableIcons[index];
          return InkWell(
            // customBorder: const CircleBorder(),
            borderRadius: designSystem.borderRadius[16]!,
            onTap: () {
              widget.onSelectIcon(icon);
              setState(() {
                _pickedIcon = icon;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: designSystem.borderRadius[16]!,
                border: _pickedIcon == icon ? Border.all(color: colors.primary, width: 3, style: BorderStyle.solid) : null,
              ),
              child: Center(
                child: Icon(icon),
              ),
            ),
          );
        },
      ),
    );
  }
}
