import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/cart_provider.dart';
import 'package:ecommerce_app/llm_recommended_provider.dart';
import 'package:ecommerce_app/svd_recommended_provider.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // For LLM Model recommendations to be shown on this screen.
  bool areProductsRecommended = false;
  final _firestore = FirebaseFirestore.instance;
  bool hasBought = false;

  @override
  Widget build(BuildContext context) {
    final svdRecommendedProducts = Provider.of<SVDRecommendedProvider>(context);
    final llmRecommendedProducts = Provider.of<LLMRecommendedProvider>(context);
    if (llmRecommendedProducts.items.isNotEmpty) {
      setState(() {
        areProductsRecommended = true;
      });
    }

    void getSVDRecommendedProducts({String userId = "HAAA"}) async {
      Response response = await get(
        Uri.parse("http://10.0.2.2:3000/?query=$userId"),
      );
      // Gets full string containing all recommended ids.
      String temp = response.body;
      log("im logging the raw string from localhost: $temp");
      String productIds = temp.replaceAll("\"", "");
      // Split that string into a list of individual recommended ids.
      List<String> products = productIds.split(',');
      // Iterate through that list, convert the string id to integer id, and add it to list of recommended products.
      for (String item in products) {
        log(item);
        int id = int.parse(item);
        svdRecommendedProducts.addItem(id);
      }
      // ! DO THIS FOR LLM MODEL.
      // setState(() {
      //   areProductsRecommended = true;
      // });
    }

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: cart.items.isEmpty
            ? null
            : () {
                cart.clearCart();
                llmRecommendedProducts.clear();
                getSVDRecommendedProducts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order issued!")),
                );
                setState(() {
                  hasBought = true;
                });
                // Navigator.of(context).pop();
              },
        child: const Text("Buy"),
      ),
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: !hasBought
          ? cart.items.isEmpty
              ? const Center(
                  child: Text("No items in cart"),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(30),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.numOfItems,
                        itemBuilder: (context, index) {
                          return ProductItem(
                              product: Model.fromCart(cart.items[index]));
                        },
                      ),
                      // LLM Model Recommendations.
                      if (areProductsRecommended)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Frequently bought with:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Consumer<LLMRecommendedProvider>(
                              builder: (context, value, _) {
                                return ListView.builder(
                                  padding: const EdgeInsets.all(30),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.items.length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('products')
                                          .where(
                                            "product_sub_catagory",
                                            isEqualTo:
                                                value.items[index].category,
                                          )
                                          .limit(2)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }

                                        final docs = snapshot.data!.docs;
                                        return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: docs.length,
                                          itemBuilder: (context, index) {
                                            // docs.sort((a, b) {
                                            //   return (a["product_rating"] as num)
                                            //       .compareTo(
                                            //           b["product_rating"] as num);
                                            // });
                                            final data = docs[index];
                                            return ProductItem(
                                              product: Model.fromSnapshot(data
                                                  as DocumentSnapshot<
                                                      Map<String, dynamic>>),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                )
          : Center(
              child: Column(
                children: [
                  const Text("Rate your purchase:"),
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: customTextFieldDecoration,
                  ),
                  const SizedBox(height: 10,),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("Submit"))
                ],
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
