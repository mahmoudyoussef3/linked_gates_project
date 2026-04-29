import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.isFavorite, this.onTap});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isFavorite ? AppColors.error : Colors.white;
    return Tooltip(
      message: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      child: Material(
        color: Colors.black.withValues(alpha: 0.25),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(6.r),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: color,
                size: 18.r,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
