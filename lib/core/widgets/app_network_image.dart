import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/app_colors.dart';
import 'app_shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.image_outlined,
    this.errorIcon = Icons.broken_image_outlined,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final image = _buildImage(context);
    if (borderRadius == null) {
      return image;
    }
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _buildImage(BuildContext context) {
    if (url.isEmpty) {
      return _fallback(placeholderIcon);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        final cacheWidth = (constraints.maxWidth * devicePixelRatio).round();
        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          memCacheWidth: cacheWidth > 0 ? cacheWidth : null,
          fadeInDuration: const Duration(milliseconds: 250),
          fadeInCurve: Curves.easeOut,
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: (_, __) => const _ImageShimmerPlaceholder(),
          errorWidget: (_, __, ___) => _fallback(errorIcon),
        );
      },
    );
  }

  Widget _fallback(IconData icon) {
    return Container(
      color: AppColors.muted,
      alignment: Alignment.center,
      child: Icon(icon, size: 40.r, color: AppColors.textSecondary),
    );
  }
}

class _ImageShimmerPlaceholder extends StatelessWidget {
  const _ImageShimmerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        color: AppColors.shimmerBase,
      ),
    );
  }
}
