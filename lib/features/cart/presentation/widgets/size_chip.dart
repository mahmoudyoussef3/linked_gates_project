import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/styles/app_colors.dart';
import 'package:linked_gates_project/core/styles/app_text_styles.dart';

class SizeChip extends StatelessWidget {
  const SizeChip({super.key, required this.size});

  final String size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.muted),
      ),
      child: Text(size, style: AppTextStyles.caption),
    );
  }
}
