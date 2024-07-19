import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/products_model.dart';

class ProductsProvider extends ChangeNotifier {
  static final List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  ProductModel findProById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      _productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: double.tryParse(
              element.get('price'),
            ) ??
                0,
            salePrice: element.get('salePrice'),
            isOnSale: element.get('isOnSale'),
            discription: element.get('description'),
            ratings: element.get('ratings'),
            size: element.get('size')
          ),
        );
      });

      notifyListeners();
    } catch (e) {
      print('Error in fetchProducts: $e');
    }
  }
}