import 'package:ecommerce_app/cart_provider.dart';
import 'package:ecommerce_app/cart_screen.dart';
import 'package:ecommerce_app/constants/routes.dart';
import 'package:ecommerce_app/llm_recommended_provider.dart';
import 'package:ecommerce_app/my_home/home_two.dart';
import 'package:ecommerce_app/svd_recommended_provider.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initializeTheApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SVDRecommendedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LLMRecommendedProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          welcomeScreen: (context) => const Welcome(),
          homeScreen: (context) => HomePage(),
          authenticationScreen: (context) => const LoginView(),
          cartScreen: (context) => const CartScreen(),
        },
        initialRoute: welcomeScreen,
      ),
    );
  }
}
