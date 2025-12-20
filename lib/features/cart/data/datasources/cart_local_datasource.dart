import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCart();
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(int productId);
  Future<void> updateCartItem(int productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CartItem>> getCart() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.cartStorageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cart: ${e.toString()}');
    }
  }

  @override
  Future<void> addToCart(CartItem item) async {
    try {
      final cart = await getCart();
      final existingItemIndex = cart.indexWhere((i) => i.productId == item.productId);
      
      if (existingItemIndex != -1) {
        final existingItem = cart[existingItemIndex];
        final updatedItem = CartItemModel(
          productId: existingItem.productId,
          title: existingItem.title,
          price: existingItem.price,
          image: existingItem.image,
          quantity: existingItem.quantity + item.quantity,
        );
        cart[existingItemIndex] = updatedItem;
      } else {
        cart.add(CartItemModel.fromEntity(item));
      }

      await _saveCart(cart);
    } catch (e) {
      throw CacheException('Failed to add to cart: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      final cart = await getCart();
      cart.removeWhere((item) => item.productId == productId);
      await _saveCart(cart);
    } catch (e) {
      throw CacheException('Failed to remove from cart: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCartItem(int productId, int quantity) async {
    try {
      final cart = await getCart();
      final itemIndex = cart.indexWhere((item) => item.productId == productId);
      
      if (itemIndex != -1) {
        if (quantity <= 0) {
          cart.removeAt(itemIndex);
        } else {
          final item = cart[itemIndex];
          final updatedItem = CartItemModel(
            productId: item.productId,
            title: item.title,
            price: item.price,
            image: item.image,
            quantity: quantity,
          );
          cart[itemIndex] = updatedItem;
        }
        await _saveCart(cart);
      }
    } catch (e) {
      throw CacheException('Failed to update cart item: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(AppConstants.cartStorageKey);
    } catch (e) {
      throw CacheException('Failed to clear cart: ${e.toString()}');
    }
  }

  Future<void> _saveCart(List<CartItem> cart) async {
    final jsonList = cart.map((item) => CartItemModel.fromEntity(item).toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(AppConstants.cartStorageKey, jsonString);
  }
}


