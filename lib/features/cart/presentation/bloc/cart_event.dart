import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCartRequested extends CartEvent {
  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  const AddToCartRequested({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [productId, title, price, image, quantity];
}

class RemoveFromCartRequested extends CartEvent {
  final int productId;

  const RemoveFromCartRequested(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateCartItemRequested extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItemRequested({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCartRequested extends CartEvent {
  const ClearCartRequested();
}


