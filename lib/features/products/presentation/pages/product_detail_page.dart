import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/widgets/toast.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(LoadProductDetails(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.authPrimary,
                ),
              ),
            );
          } else if (state is ProductDetailLoaded) {
              final product = state.product;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Container(
                    height: 350,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: AppColors.authInputBackground,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusSizeLarge,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusSizeLarge,
                      ),
                      child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.authPrimary,
                            ),
                          ),
                      ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textHint,
                          size: 60,
                        ),
                      ),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                    ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                          style: const TextStyle(
                            fontSize: Dimensions.fontSizeExtraLarge,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                          ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text(
                            product.price.toPriceString(),
                              style: const TextStyle(
                                fontSize: Dimensions.fontSizeOverLarge,
                                  fontWeight: FontWeight.bold,
                                color: AppColors.authPrimary,
                                ),
                          ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.authInputBackground,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSizeDefault,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                            children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating.rate}',
                                    style: const TextStyle(
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                              const SizedBox(width: 4),
                                  Text(
                                    '(${product.rating.count})',
                                    style: const TextStyle(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.authPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusSizeDefault,
                            ),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.authPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        const Text(
                            'Description',
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text(
                            product.description,
                          style: const TextStyle(
                            fontSize: Dimensions.fontSizeDefault,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          SizedBox(
                            width: double.infinity,
                          height: Dimensions.buttonHeightDefault,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      AddToCartRequested(
                                        productId: product.id,
                                        title: product.title,
                                        price: product.price,
                                        image: product.image,
                                      ),
                                    );
                                Toast.show(
                                  context,
                                  message: 'Added to cart',
                                  icon: Icons.shopping_cart,
                                );
                              },
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.textWhite,
                            ),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.authPrimary,
                              foregroundColor: AppColors.textWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSizeExtraLarge,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.paddingSizeLarge +
                              MediaQuery.of(context).padding.bottom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              );
          } else if (state is ProductDetailError) {
              return Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.error.withValues(alpha: 0.5),
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
                        context.read<ProductDetailBloc>().add(
                              LoadProductDetails(widget.productId),
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
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                const Text(
                  'Product not found',
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
    );
  }
}

