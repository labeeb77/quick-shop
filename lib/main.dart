import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/products/presentation/bloc/product_list_bloc.dart';
import 'features/products/presentation/bloc/product_detail_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    await di.init();

    Bloc.observer = SimpleBlocObserver();
  } catch (e, stackTrace) {
    debugPrint('Error initializing Firebase/app: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  runApp(const QuickShopApp());
}

class QuickShopApp extends StatelessWidget {
  const QuickShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(const CheckAuthStatus()),
        ),
        BlocProvider(create: (_) => di.sl<ProductListBloc>()),
        BlocProvider(create: (_) => di.sl<ProductDetailBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Quick Shop',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('${bloc.runtimeType} $error');
  }
}
