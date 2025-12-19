import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCart;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;
  final UpdateCartItemUseCase updateCartItem;
  final ClearCartUseCase clearCart;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartItem,
    required this.clearCart,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCartRequested>(_onAddToCartRequested);
    on<RemoveFromCartRequested>(_onRemoveFromCartRequested);
    on<UpdateCartItemRequested>(_onUpdateCartItemRequested);
    on<ClearCartRequested>(_onClearCartRequested);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await getCart(const NoParams());

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await addToCart(AddToCartParams(
      productId: event.productId,
      title: event.title,
      price: event.price,
      image: event.image,
      quantity: event.quantity,
    ));

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const LoadCart()),
    );
  }

  Future<void> _onRemoveFromCartRequested(
    RemoveFromCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeFromCart(RemoveFromCartParams(
      productId: event.productId,
    ));

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const LoadCart()),
    );
  }

  Future<void> _onUpdateCartItemRequested(
    UpdateCartItemRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartItem(UpdateCartItemParams(
      productId: event.productId,
      quantity: event.quantity,
    ));

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const LoadCart()),
    );
  }

  Future<void> _onClearCartRequested(
    ClearCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await clearCart(const NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartLoaded([])),
    );
  }
}

