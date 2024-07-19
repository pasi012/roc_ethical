import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = productProviders.getOnSaleProducts;
    bool _isEmpty = false;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: productOnSale.isEmpty
          ? const EmptyProdWidget(text: 'No products belong to this category',)
          : Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: size.width / (size.height * 0.40),
                children: List.generate(productOnSale.length, (index) {
                  return ChangeNotifierProvider.value(
                      value: productOnSale[index], child: (const OnSaleWidget()));
                }),
              ),
          ),
    );
  }
}
