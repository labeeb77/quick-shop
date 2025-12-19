import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      productId: item.productId,
      title: item.title,
      price: item.price,
      image: item.image,
      quantity: item.quantity,
    );
  }
}


