import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProducts;

  ProductListBloc({
    required this.getProducts,
  }) : super(ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    final result = await getProducts(const NoParams());

    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(products, filteredProducts: products)),
    );
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) {
    if (state is! ProductListLoaded) return;

    final currentState = state as ProductListLoaded;
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(currentState.copyWith(
        filteredProducts: currentState.products,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.products.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    emit(currentState.copyWith(
      filteredProducts: filtered,
      searchQuery: event.query,
    ));
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<ProductListState> emit,
  ) {
    if (state is! ProductListLoaded) return;

    final currentState = state as ProductListLoaded;
    emit(currentState.copyWith(
      filteredProducts: currentState.products,
      searchQuery: '',
    ));
  }
}

