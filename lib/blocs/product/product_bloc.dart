import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<FetchProductsEvent>(onFetchProducts);
     on<UpdateProductQuantityEvent>(onUpdateProductQuantity);
  }

  void onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.fetchProducts(event.token);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Failed to fetch products: ${e.toString()}"));
    }
  }

void onUpdateProductQuantity(UpdateProductQuantityEvent event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      try {
        final currentState = state as ProductLoaded;
        final updatedProducts = currentState.products.map((product) {
          return product.id == event.product.id
              ? product.copyWith(quantity: event.quantity)
              : product;
        }).toList();
        print(updatedProducts[0].quantity);
        emit(ProductLoaded(updatedProducts));
      } catch (e) {
        emit(ProductError("Failed to update product quantity: ${e.toString()}"));
      }
    }
  }
   
}
