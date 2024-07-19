import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:roc_ethical/screens/auth/auth_home.dart';
import 'package:roc_ethical/screens/auth/login.dart';
import 'consts/firebase_const.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/products_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/btm_bar.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishListProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
      final User? user = authInstance.currentUser;

      await productsProvider.fetchProducts();
      // await cartProvider.fetchCart();
      // await wishListProvider.fetchWishlist();
      // await orderProvider.fetchOrders();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarScreen(),
      ));

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 10,),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
