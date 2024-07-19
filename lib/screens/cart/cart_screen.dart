import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:roc_ethical/screens/payments/payment_configurations.dart';
import 'package:uuid/uuid.dart';
import '../../consts/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? paymentIntent;

  String os = Platform.operatingSystem;

  // Google Pay Button
  Widget googlePayBtn(String amount) {
    return GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: amount,
          status: PaymentItemStatus.final_price,
        )
      ],
      width: double.infinity,
      type: GooglePayButtonType.pay,
      onPaymentResult: _handlePaymentResult,
      margin: const EdgeInsets.only(top: 15),
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Apple Pay Button
  Widget applePayBtn(String amount) {
    return ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: amount,
          status: PaymentItemStatus.final_price,
        )
      ],
      style: ApplePayButtonStyle.black,
      width: double.infinity,
      type: ApplePayButtonType.buy,
      onPaymentResult: _handlePaymentResult,
      margin: const EdgeInsets.only(top: 15),
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'My Cart',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  Text(
                    "Total Items (${cartItemsList.length})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ),
                          ));
                    },
                  ),
                ),
                _checkout(ctx: context),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    double total = 0.0;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(children: [
              FittedBox(
                child: TextWidget(
                  text: "Subtotal:",
                  color: color,
                  textSize: 18,
                  isTitle: true,
                ),
              ),
              const Spacer(),
              FittedBox(
                child: TextWidget(
                  text: '\$${total.toStringAsFixed(2)}',
                  color: color,
                  textSize: 25,
                  isTitle: true,
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Platform.isAndroid ? googlePayBtn(total.toStringAsFixed(2)) : applePayBtn(total.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  void _handlePaymentResult(Map<String, dynamic> paymentResult) {
    // Process the payment result here
    print('Payment Result: $paymentResult');

    final cartProvider = Provider.of<CartProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);

    User? user = authInstance.currentUser;
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    cartProvider.getCartItems.forEach((key, value) async {
      final getCurrProduct = productProvider.findProById(
        value.productId,
      );
      try {
        double total = 0.0;

        cartProvider.getCartItems.forEach((key, value) {
          final getCurrProduct = productProvider.findProById(value.productId);
          total += (getCurrProduct.isOnSale
                  ? getCurrProduct.salePrice
                  : getCurrProduct.price) *
              value.quantity;
        });

        String address;
        String _uid = user!.uid;
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .get();
        if (userDoc == null) {
          return;
        } else {
          address = userDoc.get('shipping-address');
        }

        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
          'orderId': orderId,
          'userId': user.uid,
          'productId': value.productId,
          'price': (getCurrProduct.isOnSale
                  ? getCurrProduct.salePrice
                  : getCurrProduct.price) *
              value.quantity,
          'totalPrice': total.toStringAsFixed(2),
          'shipping-address': address,
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.imageUrl,
          'size': getCurrProduct.size,
          'userName': user.displayName,
          'orderDate': Timestamp.now(),
        });
        await cartProvider.clearOnlineCart();
        cartProvider.clearLocalCart();
        ordersProvider.fetchOrders();
        await Fluttertoast.showToast(
          msg: "Your order has been placed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
      } finally {}
    });
  }
}
