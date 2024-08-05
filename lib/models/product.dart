class Product {
  final int? id;
  final String? code;
  final String? name;
  final int? unitId;
  final String? price;
  final String? secondaryPrice;
  final String? sku;
  final String? packSize;
  final String? stock;
  final String? type;
  final int? categoryId;
  final String? notes;
  final String? vat;
  final String? status;
  final String? stockQty;
  // Add the quantity field here
  int quantity;

  Product({
    this.id,
    this.code,
    this.name,
    this.unitId,
    this.price,
    this.secondaryPrice,
    this.sku,
    this.packSize,
    this.stock,
    this.type,
    this.categoryId,
    this.notes,
    this.vat,
    this.status,
    this.stockQty,
    this.quantity = 0, // Initialize quantity to 0 by default
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      unitId: json['unit_id'],
      price: json['price'],
      secondaryPrice: json['secondary_price'],
      sku: json['sku'],
      packSize: json['pack_size'],
      stock: json['stock'],
      type: json['type'],
      categoryId: json['category_id'],
      notes: json['notes'],
      vat: json['vat'],
      status: json['status'],
      stockQty: json['stockQty'],
      // Initialize quantity from JSON if available, otherwise use 0
      quantity: json['quantity'] ?? 0,
    );
  }

  // Add a copyWith method to create a new Product instance with updated quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      code: code,
      name: name,
      unitId: unitId,
      price: price,
      secondaryPrice: secondaryPrice,
      sku: sku,
      packSize: packSize,
      stock: stock,
      type: type,
      categoryId: categoryId,
      notes: notes,
      vat: vat,
      status: status,
      stockQty: stockQty,
      quantity: quantity ?? this.quantity,
    );
  }
}