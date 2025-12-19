import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDetails extends ProductDetailEvent {
  final int productId;

  const LoadProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}

