import 'package:equatable/equatable.dart';

import '../../models/product.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends ProductEvent {
  final String token;

  FetchProductsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class UpdateProductQuantityEvent extends ProductEvent {
  final Product product;
  final int quantity;

  UpdateProductQuantityEvent({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
