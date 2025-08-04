import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class PhoneField extends StatelessWidget {
  final String phoneNumber;

  const PhoneField({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final parts = phoneNumber.split('-');
    final part1 = parts.isNotEmpty ? parts[0] : '';
    final part2 = parts.length > 1 ? parts[1] : '';
    final part3 = parts.length > 2 ? parts[2] : '';

    Widget buildBox(String text) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: OrmeeColor.gray[10],
          ),
          alignment: Alignment.centerLeft,
          child: Label1Regular14(text: text, color: OrmeeColor.gray[50]),
        ),
      );
    }

    return Row(
      children: [
        buildBox(part1),
        SizedBox(width: 2),
        Label1Regular14(text: '-', color: OrmeeColor.gray[90]),
        SizedBox(width: 2),
        buildBox(part2),
        SizedBox(width: 2),
        Label1Regular14(text: '-', color: OrmeeColor.gray[90]),
        SizedBox(width: 2),
        buildBox(part3),
      ],
    );
  }
}
