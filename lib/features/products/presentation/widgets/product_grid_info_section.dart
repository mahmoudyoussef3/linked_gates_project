import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';

class ProductGridInfoSection extends StatelessWidget {
  const ProductGridInfoSection({
    super.key,
    required this.title,
    required this.priceText,
  });

  final String title;
  final String priceText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              priceText,
              style: AppTextStyles.price,
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
