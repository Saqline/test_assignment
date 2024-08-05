import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/product/product_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/product_repository.dart';
import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/checkout_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();
  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        routes: {
          '/': (context) => LoginScreen(),
          //'/products': (context) => ProductListScreen(token: '',),
          '/checkout': (context) => CheckoutScreen(),
          
        },
      ),
    );
  }
}
