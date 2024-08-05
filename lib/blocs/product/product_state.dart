import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}
// class ProductQuantityUpdated extends ProductState {
//   final Product product;
//   final int quantity;

//   ProductQuantityUpdated({required this.product, required this.quantity});

//   @override
//   List<Object> get props => [product, quantity];
// }

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}
