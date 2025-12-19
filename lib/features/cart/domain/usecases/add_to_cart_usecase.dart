import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<void, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async {
    final cartItem = CartItem(
      productId: params.productId,
      title: params.title,
      price: params.price,
      image: params.image,
      quantity: params.quantity,
    );
    return await repository.addToCart(cartItem);
  }
}

class AddToCartParams extends Equatable {
  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  const AddToCartParams({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [productId, title, price, image, quantity];
}

