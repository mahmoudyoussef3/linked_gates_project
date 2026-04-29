import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_network_image.dart';
import 'favorite_button.dart';

class ProductGridImageSection extends StatelessWidget {
  const ProductGridImageSection({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.isFavorite,
    this.onFavoriteTap,
  });

  final int productId;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Hero(
        tag: 'product_$productId',
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(url: imageUrl),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: FavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
