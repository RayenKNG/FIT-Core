// Sesuai modul hal.22
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderGlass)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderGlass)),
      ],
    );
  }
}
