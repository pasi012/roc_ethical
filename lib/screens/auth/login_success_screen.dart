import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_ethical/screens/btm_bar.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key});

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Image.asset(
            'assets/images/img.png',
            fit: BoxFit.fill,
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/images/img_1.png',
            fit: BoxFit.fill,
            height: 50,
            width: 200,
          ),
          const SizedBox(height: 30,),
          const Text(
            "You have Successfully registered in\nour app . Start shopping now !",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // No background color
                  elevation: MaterialStateProperty.all<double>(0), // Remove shadow/elevation
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.black, width: 2), // Blue border
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners (optional)
                    ),
                  ),
                ),
                onPressed: () async {

                  final productsProvider =
                  Provider.of<ProductsProvider>(context, listen: false);
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  final wishListProvider =
                  Provider.of<WishlistProvider>(context, listen: false);
                  final orderProvider = Provider.of<OrdersProvider>(context, listen: false);

                  await productsProvider.fetchProducts();
                  await cartProvider.fetchCart();
                  await wishListProvider.fetchWishlist();
                  await orderProvider.fetchOrders();

                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const BottomBarScreen(),
                  ));

                },
                child: const Text(
                  "Start Shopping",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}
