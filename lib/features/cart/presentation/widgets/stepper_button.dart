import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/styles/app_colors.dart';

class StepperButton extends StatelessWidget {
  const StepperButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(icon, size: 16.r, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}