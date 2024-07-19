import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/firebase_const.dart';
import '../inner_screens/product_details.dart';
import '../models/products_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';
import 'text_widget.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({super.key});
  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isIWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: productModel.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(children: [
          Flexible(
            flex: 14,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 2,
                width: size.width * 0.5,
                boxFit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextWidget(
                      text: productModel.title,
                      color: Colors.black,
                      maxLines: 1,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: productModel.id,
                        isInWishlist: _isIWishlist,
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: PriceWidget(
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: productModel.isOnSale,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            flex: 4,
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final User? user = authInstance.currentUser;
                  if (user == null) {
                    GlobalMethods.errorDialog(
                        subtitle: 'No user found, Please login first!',
                        context: context);
                    return;
                  }
                  if (_isInCart) {
                    GlobalMethods.errorDialog(
                        subtitle: 'Product already exists in cart!',
                        context: context);
                    return;
                  }
                  await GlobalMethods.addToCart(
                      productId: productModel.id, quantity: 1, context: context);
                  await cartProvider.fetchCart();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    )),
                child: TextWidget(
                  text: _isInCart ? 'In cart' : ' Add To Cart',
                  maxLines: 1,
                  color: color,
                  textSize: 20,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
