import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/widgets/app_network_image.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 72.w,
        height: 72.w,
        child: AppNetworkImage(url: imageUrl),
      ),
    );
  }
}