import 'package:flutter/material.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  });
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
        child: Row(
      children: [
        TextWidget(
          isTitle: true,
          text: '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          color: Colors.black,
          textSize: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        Visibility(
          visible: isOnSale? true :false,
          child: Text(
            '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    ));
  }
}
