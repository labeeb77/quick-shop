import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(const LoadCart());
    });
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
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<CartBloc>().add(const LoadCart());
              });
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.authPrimary,
                  ),
                ),
              );
            }

            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.authPrimary,
                  ),
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
                        child: const Text('Continue Shopping'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeLarge,
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(item: state.items[index]);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                state.total.toPriceString(),
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Delivery',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Divider(color: AppColors.authBorder),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Estimated Total',
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                state.total.toPriceString(),
                                style: const TextStyle(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          SizedBox(
                            width: double.infinity,
                            height: Dimensions.buttonHeightDefault,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/checkout');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.textPrimary,
                                foregroundColor: AppColors.textWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSizeExtraLarge,
                                  ),
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
                        ],
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
                        context.read<CartBloc>().add(const LoadCart());
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
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.textHint.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  const Text(
                    'No cart items',
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
