import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String productCategoryName;
  final double price;
  final double salePrice;
  final bool isOnSale;
  final String discription;
  final String ratings;
  final String size;
   // New field to store prices for different sizes

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.productCategoryName,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
    required this.discription,
    required this.ratings,
    required this.size,
    // Initialize the new field
  });

}
