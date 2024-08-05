import 'package:e_commerce_app/blocs/product/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../models/product.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.name ?? 'Unnamed Product'),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: \$${widget.product.price ?? 'N/A'}'),
          Text('Pack Size: ${widget.product.packSize}'),
          Text('Stock: ${widget.product.stock ?? 'N/A'}')
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: _quantity > 0
                ? () {
                    setState(() {
                      _quantity--;
                      BlocProvider.of<ProductBloc>(context).add(UpdateProductQuantityEvent(product: widget.product, quantity: _quantity));
                    });
                  }
                : null,
          ),
          Text(_quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: 
           // widget.product.stock != null && widget.product.stock! > _quantity? 
                () {
                    setState(() {
                      _quantity++;
                      BlocProvider.of<ProductBloc>(context).add(UpdateProductQuantityEvent(product: widget.product, quantity: _quantity));
                    });
                  }
                //: null,
          ),
        ],
      ),
     
    );
  }
}
