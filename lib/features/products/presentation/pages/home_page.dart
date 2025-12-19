import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import 'product_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProductListPage(),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

