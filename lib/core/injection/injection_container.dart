import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:quick_shop/core/network/api_client.dart';
import 'package:quick_shop/core/network/network_info.dart' show NetworkInfo;
import 'package:quick_shop/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:quick_shop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_shop/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:quick_shop/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:quick_shop/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:quick_shop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quick_shop/features/cart/data/datasources/cart_local_datasource.dart' show CartLocalDataSource, CartLocalDataSourceImpl;
import 'package:quick_shop/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:quick_shop/features/cart/domain/repositories/cart_repository.dart';
import 'package:quick_shop/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:quick_shop/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:quick_shop/features/cart/domain/usecases/get_cart_usecase.dart' show GetCartUseCase;
import 'package:quick_shop/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:quick_shop/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:quick_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quick_shop/features/products/data/datasources/product_remote_datasource.dart';
import 'package:quick_shop/features/products/data/repositories/product_repository_impl.dart';
import 'package:quick_shop/features/products/domain/repositories/product_repository.dart';
import 'package:quick_shop/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:quick_shop/features/products/domain/usecases/get_products_usecase.dart' show GetProductsUseCase;
import 'package:quick_shop/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:quick_shop/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> init() async {
  
  //  Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  // 
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  
  sl.registerFactory(
    () => ProductListBloc(
      getProducts: sl(),
    ),
  );
  sl.registerFactory(
    () => ProductDetailBloc(
      getProductDetails: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );


  sl.registerFactory(
    () => CartBloc(
      getCart: sl(),
      addToCart: sl(),
      removeFromCart: sl(),
      updateCartItem: sl(),
      clearCart: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => NetworkInfo(Connectivity()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}

