import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inner_screens/cat_screen.dart';
import '../provider/dark_theme_provider.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key,
        required this.catText,
        required this.imgPath,
        required this.passedColor});
  final String catText, imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    var color2 = Utils(context).getTheme;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Image container
            Container(
              height: _screenWidth * 0.6,
              width: _screenWidth * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Category text overlay
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: color2
                        ? Colors.black
                        : Colors.white
                  ),
                  child: TextWidget(
                    text: catText,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}