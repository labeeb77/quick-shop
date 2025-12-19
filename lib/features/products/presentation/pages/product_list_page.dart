import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/widgets/search_bar.dart' as custom;
import '../bloc/product_list_bloc.dart';
import '../bloc/product_list_event.dart';
import '../bloc/product_list_state.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  final bool showBottomNav;

  const ProductListPage({super.key, this.showBottomNav = false});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(const LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          'Products',
          style: TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeDefault,
            ),
            child: custom.SearchBar(
              controller: _searchController,
              hintText: 'Search for products',
              onClear: () {
                context.read<ProductListBloc>().add(const ClearSearch());
              },
              onChanged: (value) {
                context.read<ProductListBloc>().add(SearchProducts(value));
              },
            ),
          ),
          // Product grid
          Expanded(
            child: BlocConsumer<ProductListBloc, ProductListState>(
              listener: (context, state) {
                // Sync search controller with bloc state
                if (state is ProductListLoaded && state.searchQuery.isEmpty) {
                  if (_searchController.text.isNotEmpty) {
                    _searchController.clear();
                  }
                }
              },
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.authPrimary,
                      ),
                    ),
                  );
                } else if (state is ProductListLoaded) {
                  final productsToShow = state.filteredProducts;
                  final hasSearchQuery = state.searchQuery.isNotEmpty;

                  if (productsToShow.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasSearchQuery
                                ? Icons.search_off
                                : Icons.shopping_bag_outlined,
                            size: 80,
                            color: AppColors.textHint.withOpacity(0.5),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            hasSearchQuery
                                ? 'No products found for "${state.searchQuery}"'
                                : 'No products available',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: Dimensions.fontSizeLarge,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (hasSearchQuery) ...[
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            TextButton(
                              onPressed: () {
                                context.read<ProductListBloc>().add(const ClearSearch());
                                _searchController.clear();
                              },
                              child: const Text(
                                'Clear search',
                                style: TextStyle(
                                  color: AppColors.authPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Dimensions.paddingSizeLarge,
                          mainAxisSpacing: Dimensions.paddingSizeLarge,
                          childAspectRatio:
                              0.65, // Taller cards to prevent overflow
                        ),
                    itemCount: productsToShow.length,
                    itemBuilder: (context, index) {
                      final product = productsToShow[index];
                      return ProductCard(product: product);
                    },
                  );
                } else if (state is ProductListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: AppColors.error.withOpacity(0.5),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: Dimensions.fontSizeLarge,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductListBloc>().add(
                              const LoadProducts(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.authPrimary,
                            foregroundColor: AppColors.textWhite,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraLarge,
                              vertical: Dimensions.paddingSizeDefault,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusSizeExtraLarge,
                              ),
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: AppColors.textHint.withOpacity(0.5),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      const Text(
                        'No products loaded',
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
