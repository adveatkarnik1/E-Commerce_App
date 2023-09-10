import 'package:ecommerce_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:ecommerce_app/services/auth/providers/firebase/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/utils/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _auth = AuthService.firebase();

  bool isLogin = true;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void authenticate() async {
      final email = _email.text;
      final password = _password.text;

      try {
        isLogin
            ? await _auth.login(
                email: email,
                password: password,
              )
            : await _auth.createUser(
                email: email,
                password: password,
              );
      } on WeakPasswordAuthException catch (_) {
        await showErrorDialog(
          context,
          "Weak Password!",
        );
        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } on EmailInUseAuthException catch (_) {
        await showErrorDialog(
          context,
          "A user with these credentials has already been registered.",
        );

        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } on UserNotFoundAuthException catch (_) {
        await showErrorDialog(
          context,
          "User not found!",
        );
        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } on WrongCredentialsAuthException catch (_) {
        await showErrorDialog(
          context,
          "Wrong credentials!",
        );

        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } on InvalidEmailAuthException catch (_) {
        await showErrorDialog(
          context,
          "Invalid email. Please enter a valid id.",
        );

        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } on GenericAuthException catch (e) {
        await showErrorDialog(context, e.toString());
        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      } catch (e) {
        await showErrorDialog(context, e.toString());
        // Clears the wrong inputs.
        setState(() {
          _email.text = "";
          _password.text = "";
        });
        return;
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(homeScreen);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/flipkart_logo.png",
                      scale: 5,
                    ),
                    const SizedBox(width: 10),
                    isLogin
                        ? Text(
                            "Login",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "Register",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
                // const Expanded(child: SizedBox()),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  child: TextField(
                    decoration: customTextFieldDecoration.copyWith(
                      hintText: "Your email address...",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  child: TextField(
                    decoration: customTextFieldDecoration.copyWith(
                      hintText: "Your password...",
                    ),
                    obscureText: true,
                    controller: _password,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: authenticate,
                  child: const Text("Submit"),
                ),
                // const Expanded(child: SizedBox()),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLogin
                          ? const Text("Not signed up yet?")
                          : const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: isLogin
                            ? const Text("Sign Up!")
                            : const Text("Sign In!"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var customTextFieldDecoration = InputDecoration(
  hintText: "Enter a value",
  hintStyle: const TextStyle(color: Colors.grey),
  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue.shade300,
      width: 2,
    ),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromARGB(255, 0, 103, 187),
      width: 2,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
);
