import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_shimmer.dart';
import '../provider/product_provider.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: Stack(
                children: [
                  AppShimmerBox(
                    height: double.infinity,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: AppShimmerBox(
                      height: 24.r,
                      width: 24.r,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AppShimmerBox(height: 16),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: AppShimmerBox(height: 14, width: 80),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class ProductShimmerList extends StatelessWidget {
  const ProductShimmerList({
    super.key,
    required this.crossAxisCount,
    required this.layout,
  });

  final int crossAxisCount;
  final ProductLayout layout;

  @override
  Widget build(BuildContext context) {
    if (layout == ProductLayout.list) {
      return ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => const ProductListShimmer(),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.78,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductShimmer(),
    );
  }
}

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            AppShimmerBox(
              height: 96.w,
              width: 96.w,
              borderRadius: BorderRadius.circular(14.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(height: 16.h),
                  SizedBox(height: 8.h),
                  AppShimmerBox(height: 14.h, width: 80.w),
                  SizedBox(height: 8.h),
                  AppShimmerBox(height: 12.h),
                  SizedBox(height: 6.h),
                  AppShimmerBox(height: 12.h, width: 140.w),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppShimmerBox(
                      height: 28.r,
                      width: 28.r,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
