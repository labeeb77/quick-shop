import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCart();
  Future<Either<Failure, void>> addToCart(CartItem item);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}


