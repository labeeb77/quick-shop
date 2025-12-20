import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dimensions.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.white),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                iconPath:
                    'assets/icons/home_${currentIndex == 0 ? 'on' : 'off'}.svg',
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    context.go('/home');
                  }
                },
              ),
              _NavItem(
                iconPath:
                    'assets/icons/search_${currentIndex == 1 ? 'on' : 'off'}.svg',
                label: 'Search',
                isActive: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) {
                    context.go('/search');
                  }
                },
              ),
              _NavItem(
                iconPath:
                    'assets/icons/cart_${currentIndex == 2 ? 'on' : 'off'}.svg',
                label: 'Cart',
                isActive: currentIndex == 2,
                onTap: () {
                  if (currentIndex != 2) {
                    context.go('/cart');
                  }
                },
              ),
              _NavItem(
                iconPath:
                    'assets/icons/profile_${currentIndex == 3 ? 'on' : 'off'}.svg',
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () {
                  if (currentIndex != 3) {
                    context.go('/profile');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: Dimensions.iconSizeMedium,
            height: Dimensions.iconSizeMedium,
            colorFilter: ColorFilter.mode(
              isActive
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.fontSizeSmall,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
