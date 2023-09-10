import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/SideMenu.dart';
import 'package:ecommerce_app/model.dart';
import 'package:ecommerce_app/models/auth_user.dart';
import 'package:ecommerce_app/svd_recommended_provider.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  final user = const AuthUser(true);
  final newUser = const AuthUser(false);

  @override
  Widget build(BuildContext context) {
    final recommender = Provider.of<SVDRecommendedProvider>(context);
    final areProductsRecommended = recommender.areProductsBeingRecommended();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').limit(10).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(30),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductItem(
                      product: Model.fromQuery(product
                          as QueryDocumentSnapshot<Map<String, dynamic>>),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            if (user == newUser) const Text(
              "Trending products:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user == newUser) StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').orderBy("product_rating", descending: true).limit(5).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(30),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductItem(
                      product: Model.fromQuery(product
                          as QueryDocumentSnapshot<Map<String, dynamic>>),
                    );
                  },
                );
              },
            ),
            !areProductsRecommended
                ? const SizedBox()
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Top five products other users also bought:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<SVDRecommendedProvider>(
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
                                    .where("pid",
                                        isEqualTo: value.items[index].id)
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
                                      final data = docs[index];
                                      return ProductItem(
                                        product: Model.fromQuery(data
                                            as QueryDocumentSnapshot<
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
      ),
    );
  }
}
