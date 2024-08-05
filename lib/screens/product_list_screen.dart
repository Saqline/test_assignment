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
import '../widgets/product_item.dart'; // Import for number formatting

class ProductListScreen extends StatefulWidget {
  ProductListScreen({required this.token});
  String token;

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
      body: Column(
        children: [
          Expanded(
            child: BlocProvider(
              create: (context) => ProductBloc(ProductRepository())
                ..add(FetchProductsEvent(token: widget.token)),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocProvider(
              create: (context) => ProductBloc(ProductRepository())
                //..add(UpdateProductQuantityEvent(product: Product(), quantity: 0))
                ..add(FetchProductsEvent(token: widget.token)),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoaded) {
                    double totalPrice = 0;
                    // for (var product in state.products) {
                    //   // Debug print statements
                    //   print(
                    //       'Product: ${product.name}, Price: ${product.price}, Quantity: ${product.quantity}');
                    //   if (product.price != null &&
                    //       double.tryParse(product.price!) != null) {
                    //     totalPrice +=
                    //         product.quantity * double.parse(product.price!);
                    //   } 
                    // }

                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                        });
                        for (var product in state.products) {
                      // Debug print statements
                      print(
                          'Product: ${product.name}, Price: ${product.price}, Quantity: ${product.quantity}');
                      if (product.price != null &&
                          double.tryParse(product.price!) != null) {
                        totalPrice +=
                            product.quantity * double.parse(product.price!);
                            print("Total Price: $totalPrice");
                      } 
                    }
                     setState(() {
                        });
                        showdialog(context, totalPrice);
                      },
                      child: Text('Checkout - \$$totalPrice'),
                    );
                  } else if (state is ProductInitial) {
                    return Center(child: Text("No products available"));
                  } else {
                    return const Center(child: Text('Checkout'));
                  }
                },
              ),
            ),
          ),
        ],
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> showdialog(BuildContext context, double totalPrice) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: Text('Total price: ${totalPrice}'),
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
                // Navigate to checkout or confirm the order
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
