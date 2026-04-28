import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../products/domain/entities/product_entity.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_${product.id}',
      child: AspectRatio(
        aspectRatio: 1.1,
        child: AppNetworkImage(
          url: product.imageUrl,
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
    );
  }
}