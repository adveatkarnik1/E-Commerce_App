import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/details.dart';
import 'package:ecommerce_app/model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final Model product;
  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    void goToDeets() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(
            query: product,
          ),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 5));
    log(product.img);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: InkWell(
        onTap: goToDeets,
        child: SizedBox(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      height: 250,
                      fit: BoxFit.cover,
                      imageUrl: product.img,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Price: ₹${product.price}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "Rating: ${product.ratings}☆",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
