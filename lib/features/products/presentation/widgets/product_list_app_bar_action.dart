import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';

class ProductListAppBarAction extends StatelessWidget {
  const ProductListAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, color: AppColors.textPrimary),
              if (badge != null) Positioned(top: -4, right: -6, child: badge!),
            ],
          ),
        ),
      ),
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}
