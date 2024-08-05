import 'package:e_commerce_app/blocs/auth/auth_event.dart';
import 'package:e_commerce_app/repositories/product_repository.dart';
import 'package:e_commerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({required this.token});
  final String token;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogOutAlert(context);
                },
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProductBloc(ProductRepository())
          ..add(FetchProductsEvent(token: widget.token)),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('No products available'));
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductItem(product: product);
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('Unknown error occurred'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return Center(child: Text("No Checkout available"));
                    }
                    double totalPrice = 0;
                    for (var product in state.products) {
                      if (product.price != null && double.tryParse(product.price!) != null) {
                        totalPrice += product.quantity * double.parse(product.price!);
                      }
                    }
                    return ElevatedButton(
                      onPressed: () {
                        showdialog(context, state.products, totalPrice);
                      },
                      child: Text('Checkout - \$$totalPrice'),
                    );
                  } else if (state is ProductInitial) {
                    return Center(child: Text("No Checkout available"));
                  } else {
                    return const Center(child: Text('Checkout'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog LogOutAlert(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Logout'),
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(LogoutEvent(token: widget.token));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
              builder: (context) => LoginScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> showdialog(BuildContext context, List<Product> products, double totalPrice) {
  final filteredProducts = products.where((product) => product.quantity > 0).toList();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Checkout'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...filteredProducts.map((product) {
                double productTotalPrice = product.quantity * double.parse(product.price!);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${product.name}: ${product.quantity} x \$${product.price} = \$${productTotalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              Divider(),
              Text(
                'Total price: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              print(totalPrice);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}}