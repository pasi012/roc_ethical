import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'firebase_options.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/on_sale_screen.dart';
import 'inner_screens/product_details.dart';
import 'provider/dark_theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/products_provider.dart';
import 'providers/viewed_prod_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/orders/orders_widget.dart';
import 'screens/viewed_recently/viewed_recently.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MyApp(), // Wrap your app
  //   ),
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: FutureBuilder(
          future: _firebaseInitialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                // useInheritedMediaQuery: true,
                // locale: DevicePreview.locale(context),
                // builder: DevicePreview.appBuilder,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const MaterialApp(
                // useInheritedMediaQuery: true,
                // locale: DevicePreview.locale(context),
                // builder: DevicePreview.appBuilder,
                home: Scaffold(
                  body: Center(
                    child: Text('An error occured'),
                  ),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => ProductsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => WishlistProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ViewedProdProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeProvider, child) {
                return MaterialApp(
                    // useInheritedMediaQuery: true,
                    // locale: DevicePreview.locale(context),
                    // builder: DevicePreview.appBuilder,
                    debugShowCheckedModeBanner: false,
                    title: 'Grocery Shop App',
                    theme: Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const FetchScreen(),
                    routes: {
                      OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                      FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                      ProductDetails.routeName: (ctx) => const ProductDetails(),
                      WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                      OrdersScreen.routeName: (context) => const OrdersScreen(),
                      ViewedRecentlyScreen.routeName: (context) =>
                          const ViewedRecentlyScreen(),
                      RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                      LoginScreen.routeName: (ctx) => const LoginScreen(),
                      ForgetPasswordScreen.routeName: (ctx) =>
                          const ForgetPasswordScreen(),
                      CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                    });
              }),
            );
          }),
    );
  }
}
