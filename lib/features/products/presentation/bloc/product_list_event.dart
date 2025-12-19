import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductListEvent {
  const LoadProducts();
}

class SearchProducts extends ProductListEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends ProductListEvent {
  const ClearSearch();
}

