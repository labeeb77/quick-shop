import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/dimensions.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../../domain/entities/cart_item.dart';
import '../../../../core/utils/extensions.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSize16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items (${state.itemCount})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Dimensions.paddingSize16),
                  ...state.items.map((item) => _CheckoutItemRow(item: item)),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CheckoutItemRow extends StatelessWidget {
  final CartItem item;

  const _CheckoutItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall + 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item.quantity}x ${item.title}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            item.total.toPriceString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}


