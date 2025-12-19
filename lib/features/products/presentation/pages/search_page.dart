import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Search Page'),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

