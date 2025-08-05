import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class ToggleButton extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool>? onChanged;

  const ToggleButton({
    super.key,
    required this.isOn,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!isOn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 32,
        decoration: BoxDecoration(
          color: isOn ? OrmeeColor.purple[50] : OrmeeColor.gray[30],
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}