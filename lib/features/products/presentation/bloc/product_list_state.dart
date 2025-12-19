import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;

  const ProductListLoaded(
    this.products, {
    this.filteredProducts = const [],
    this.searchQuery = '',
  });

  ProductListLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
  }) {
    return ProductListLoaded(
      products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [products, filteredProducts, searchQuery];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError(this.message);

  @override
  List<Object> get props => [message];
}

