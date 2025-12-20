import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const LoadCart());
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
          'Checkout',
          style: TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.authPrimary),
              ),
            );
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined, 
                      size: 80,
                      color: AppColors.textHint.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeLarge,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.authPrimary,
                        foregroundColor: AppColors.textWhite,
                      ),
                      child: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state.items.map((item) => _CheckoutItemCard(item: item)),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        _OrderSummary(total: state.total),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05) ,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: Dimensions.buttonHeightDefault,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSizeExtraLarge,
                                ),
                              ),
                              title: const Text(
                                'Order Placed!',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              content: const Text(
                                'Thank you for your purchase.',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.read<CartBloc>().add(const ClearCartRequested());
                                    context.go('/home');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.authPrimary,
                                    foregroundColor: AppColors.textWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSizeExtraLarge,
                                      ),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge,
                                      vertical: Dimensions.paddingSizeDefault,
                                    ),
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.textWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: Dimensions.paddingSize16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(const LoadCart());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Loading...'));
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

class _CheckoutItemCard extends StatelessWidget {
  final CartItem item;

  const _CheckoutItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        border: Border.all(
          color: AppColors.authBorder,
          width: Dimensions.borderWidthDefault,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: Dimensions.imageSizeSmall,
              height: Dimensions.imageSizeSmall,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: Dimensions.imageSizeSmall,
                height: Dimensions.imageSizeSmall,
                color: AppColors.authInputBackground,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: Dimensions.imageSizeSmall,
                height: Dimensions.imageSizeSmall,
                color: AppColors.authInputBackground,
                child: const Icon(Icons.error_outline),
              ),
            ),
          ),
          
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  'Size',
                  style: TextStyle(
                    fontSize: Dimensions.fontSizeSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                          RemoveFromCartRequested(item.productId),
                        );
                      },
                      child: Icon(
                        Icons.delete_outline,
                        size: Dimensions.iconSizeSmall + 2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                          UpdateCartItemRequested(
                            productId: item.productId,
                            quantity: item.quantity + 1,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        size: Dimensions.iconSizeSmall + 2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            item.total.toPriceString(),
            style: const TextStyle(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double total;

  const _OrderSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    const double deliveryFee = 0.0;
    final double estimatedTotal = total + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        border: Border.all(
          color: AppColors.authBorder,
          width: Dimensions.borderWidthDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                total.toPriceString(),
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery',
                style: TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                deliveryFee == 0 ? 'Free' : deliveryFee.toPriceString(),
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const Divider(height: Dimensions.paddingSizeLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated Total',
                style: TextStyle(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                estimatedTotal.toPriceString(),
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
