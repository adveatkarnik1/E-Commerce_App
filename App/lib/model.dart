import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_provider.dart';

class Model {
  late String id;
  late String des;
  late String title;
  // List img;
  final String img;
  late String url;
  late int price;
  late dynamic ratings;
  late int offer;
  late int category;
  late String subcategory;
  Model(
      {required this.id,
      this.title = "News Headline",
      this.des = "Some News",
      this.url = "Some url",
      required this.img,
      this.category = 0,
      this.offer = 0,
      this.price = 0,
      this.ratings = 0,
      this.subcategory = "some subcategory"});

  factory Model.fromMap(Map news) {
    return Model(
      title: news["product_name"],
      des: news["description"],
      img: news["image"],
      url: news["product_url"],
      price: news["retail_price"],
      ratings: news["product_rating"],
      offer: news["discounted_price"],
      category: news["pid"],
      subcategory: news["product_sub_catagory"],
      id: DateTime.now().toString(),
    );
  }

  factory Model.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    String image1 = data["image"];
    String image2 = image1.replaceAll("[", "");
    String image3 = image2.replaceAll("]", "");
    String image = image3.replaceAll("\"", "");
    List<String> images = [];
    if (image.contains(',')) {
      images = image.split(',');
    }
    return Model(
      img: images.isEmpty ? image : images[0],
      des: data["description"],
      title: data["product_name"],
      url: data["product_url"],
      price: data["retail_price"],
      ratings: data["product_rating"],
      offer: data["discounted_price"],
      category: data["pid"],
      subcategory: data["product_sub_catagory"],
      id: DateTime.now().toString(),
    );
  }

  factory Model.fromCart(CartProduct cartProduct) {
    return Model(
      img: cartProduct.image,
      des: cartProduct.des,
      title: cartProduct.title,
      url: "",
      price: cartProduct.price,
      ratings: cartProduct.ratings,
      offer: cartProduct.offer,
      category: cartProduct.category,
      subcategory: cartProduct.subcategory,
      id: cartProduct.id.toString(),
    );
  }

  factory Model.fromQuery(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    final uid = snapshot.id;
    // log(data["product_sub_catagory"]);
    String image1 = data["image"];
    String image2 = image1.replaceAll("[", "");
    String image3 = image2.replaceAll("]", "");
    String image = image3.replaceAll("\"", "");
    List<String> images = [];
    if (image.contains(',')) {
      images = image.split(',');
    }
    // log(uid);
    return Model(
      id: uid,
      img: images.isEmpty ? image : images[0],
      des: data["description"],
      title: data["product_name"],
      url: data["product_url"],
      price: data["retail_price"],
      ratings: data["product_rating"],
      offer: data["discounted_price"],
      category: data["pid"],
      // ! WRONG SPELLING OF CATEGORY
      subcategory: data["product_sub_catagory"],
    );
  }
}

// late String des;
//   late String title;
//   // List img;
//   final String img;
//   late String url;
//   late String price;
//   late String ratings;
//   late String offer;
//   late String category;
//   late String subcategory;
//   Model(
//       {this.title = "News Headline",
//       this.des = "Some News",
//       this.url = "Some url",
//       required this.img,
//       this.category = "some category",
//       this.offer = "999",
//       this.price = "999",
//       this.ratings = "4.3",
//       this.subcategory = "some subcategory"});

//   factory Model.fromMap(Map news) {
//     return Model(
//       title: news["product_name"],
//       des: news["description"],
//       img: news["image"],
//       url: news["product_url"],
//       price: news["retail_price"].toString(),
//       ratings: news["product_rating"].toString(),
//       offer: news["discounted_price"].toString(),
//       category: news["pid"],
//       subcategory: news["product_sub_catagory"],
//     );
//   }
