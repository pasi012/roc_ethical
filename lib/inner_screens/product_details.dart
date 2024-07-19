import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roc_ethical/screens/cart/cart_screen.dart';
import '../consts/firebase_const.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/viewed_prod_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    var color2 = Utils(context).getTheme;
    final productProviders = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProviders.findProById(productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);


    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isIWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList =
        viewedProdProvider.getViewedProdlistItems.values;
    return WillPopScope(
      onWillPop: () async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: Stack(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                    width: double.infinity,
                    height: 600,
                  ),
                  Positioned(
                    left: 20,
                    top: 40,
                    child: InkWell(
                        onTap: () => Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null,
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.black,
                        )),
                  ),
                  Positioned(
                      top: 30,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                        child: Image.asset(
                          "assets/images/img_3.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                      )),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextWidget(
                              text: getCurrentProduct.title,
                              color: color,
                              textSize: 20,
                              isTitle: true,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/img_4.png",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "(${getCurrentProduct.ratings})",
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: Column(
                        children: [
                          TextWidget(
                            text: 'Size',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                          const SizedBox(height: 10,),
                          TextWidget(
                            text: getCurrentProduct.size,
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, right: 30, bottom: 5),
                      child: TextWidget(
                        text: 'Description',
                        color: color,
                        textSize: 20,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: TextWidget(
                          text: getCurrentProduct.discription,
                          color: color,
                          textSize: 14,
                          isTitle: false,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 2.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFBED8DE),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                quantityControl(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  icon: CupertinoIcons.minus,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    controller: _quantityTextController,
                                    key: const ValueKey('quantity'),
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                    ),
                                    textAlign: TextAlign.center,
                                    cursorColor: Colors.green,
                                    enabled: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _quantityTextController.text = '1';
                                        } else {}
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                quantityControl(
                                  fct: () {
                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  icon: CupertinoIcons.plus,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                TextWidget(
                                  text: "\$${totalPrice.toStringAsFixed(2)}",
                                  color: color2 ? Colors.black : Colors.white,
                                  textSize: 15,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Image.asset("assets/images/img_5.png"),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final User? user = authInstance.currentUser;
                                    if (user == null) {
                                      GlobalMethods.errorDialog(
                                          subtitle:
                                              'No user found, Please login first!',
                                          context: context);
                                      return;
                                    }
                                    if (_isInCart) {
                                      return;
                                    }
                                    await GlobalMethods.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context,);
                                    await cartProvider.fetchCart();
                                  },
                                  child: TextWidget(
                                    text: _isInCart ? 'In Cart' : 'Add To Cart',
                                    color: color2 ? Colors.black : Colors.white,
                                    textSize: 15,
                                    isTitle: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }

  Widget quantityControl({required Function fct, required IconData icon}) {
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          fct();
        },
        child: Icon(
          icon,
          color: Colors.black,
          size: 25,
        ));
  }
}