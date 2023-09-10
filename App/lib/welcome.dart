import 'package:ecommerce_app/my_home/home_two.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';
// import 'home.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 15,
            child: Text("Loading..."),
          );
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return const LoginView();
      },
    );
  }
}
