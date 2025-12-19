import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase implements UseCase<Product, ProductDetailsParams> {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductDetailsParams params) async {
    return await repository.getProductDetails(params.id);
  }
}

class ProductDetailsParams extends Equatable {
  final int id;

  const ProductDetailsParams({required this.id});

  @override
  List<Object> get props => [id];
}

