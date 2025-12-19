import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: const Center(
        child: Text('Search Page'),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

