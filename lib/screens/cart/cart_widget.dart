import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/on_sale_screen.dart';
import '../../inner_screens/product_details.dart';
import '../../models/cart_model.dart';
import '../../models/products_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.q});
  final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isIWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: FancyShimmerImage(
                          imageUrl: getCurrProduct.imageUrl,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 16,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextWidget(
                            text:
                            '\$${((usedPrice) * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            isTitle: true,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                await cartProvider.removeOneItem(
                                    cartId: cartModel.id,
                                    productId: cartModel.productId,
                                    quantity: cartModel.quantity);
                                Fluttertoast.showToast(
                                    msg: 'Item Removed From Cart',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER);
                              },
                              child: const Icon(
                                CupertinoIcons.cart_badge_minus,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: _quantityController(
                                      fct: () {
                                        if (_quantityTextController.text == '1') {
                                          return;
                                        } else {
                                          cartProvider.reduceQuantityByOne(
                                              cartModel.productId);
                                          setState(() {
                                            _quantityTextController.text = (int.parse(
                                                _quantityTextController
                                                    .text) -
                                                1)
                                                .toString();
                                          });
                                        }
                                      },
                                      color: Colors.red,
                                      icon: CupertinoIcons.minus,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextField(
                                      controller: _quantityTextController,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'),
                                        ),
                                      ],
                                      onChanged: (v) {
                                        setState(() {
                                          if (v.isEmpty) {
                                            _quantityTextController.text = '1';
                                          } else {
                                            return;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: _quantityController(
                                      fct: () {
                                        cartProvider.increaseQuantityByOne(
                                            cartModel.productId);
                                        setState(() {
                                          _quantityTextController.text = (int.parse(
                                              _quantityTextController.text) +
                                              1)
                                              .toString();
                                        });
                                      },
                                      color: Colors.green,
                                      icon: CupertinoIcons.plus,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
