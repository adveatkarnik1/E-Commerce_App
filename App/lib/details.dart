import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_app/cart_provider.dart';
import 'package:ecommerce_app/llm_recommended_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'constants/routes.dart';
import 'model.dart';
import 'package:ecommerce_app/address.dart';

class Details extends StatefulWidget {
  Model query = new Model(img: "", id: "");
  Details({required this.query});
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void getLLMRecommendations(String query, BuildContext context) async {
    final LLMList = Provider.of<LLMRecommendedProvider>(context, listen: false);
    log("this is before response, query is $query");
    Response response =
        await get(Uri.parse("http://10.0.2.2:5000/?query=$query"));
    log("IM RESPONSE BODY: ${response.body}");
    Map data = jsonDecode(response.body);
    for (String item in data["output"]) {
      LLMList.addItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    // log("im a string");
    // log(widget.query.img);
    final ReviewList=[];
    //ReviewList.addAll(widget.query.reviews);
    String image1 = widget.query.img.replaceAll("[", "");
    String image2 = image1.replaceAll("]", "");
    String image3 = image2.replaceAll("\"", "");
    log(image3);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              splashRadius: 17,
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.black,
              )),
          IconButton(
              splashRadius: 17,
              onPressed: () {},
              icon: Icon(Icons.share, color: Colors.black)),
          IconButton(
              splashRadius: 17,
              onPressed: () {
                Navigator.of(context).pushNamed(cartScreen);
              },
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.black))
        ],
      ),
      bottomNavigationBar: new Container(
        //// Bottom Naviagtion Bar for check out and Total price
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text("Total"),
                subtitle: Text("Rs ${widget.query.price}"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
              width: 130,
              child: TextButton(
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Address(query:widget.query)));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.blue)))),
                  child: Text(
                    "Buy",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Consumer<CartProvider>(builder: (context, cart, _) {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                width: 130,
                child: TextButton(
                  onPressed: () {
                    cart.addItem(widget.query);
                    // ! CALL API THAT SENDS THIS PRODUCT TO THE ML MODEL FOR RECOMMENDATIONS.
                    log("about to execute llm function");
                    getLLMRecommendations(widget.query.subcategory, context);
                    log("finished executing llm function");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text("Added to cart!")),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black)))),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              );
            })
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(image3,
                      fit: BoxFit.cover, width: double.infinity, height: 500),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Text(widget.query.ratings.toString() , style: TextStyle(fontSize: 16),),
                          Icon(
                            Icons.star_border_rounded,
                            size: 20,
                          ),
                        ],
                      )),
                )
              ]),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.query.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
                width: 5,
              ),
              Text(
                "Description",
                style: TextStyle(
                    fontSize: 20, color: Colors.black.withOpacity(0.5)),
              ),
              SizedBox(height: 5),
              Text(widget.query.des),
              SizedBox(height: 5,),
              Text("Overall Review rating",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.5)),),
              SizedBox(height: 5,),
              Text("Reviews",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.5)),),
              SizedBox(height: 5,),
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: ReviewList.length,
                  itemBuilder:(context,index)=>ListTile(
                    hoverColor: Colors.black54,
                    contentPadding: EdgeInsets.fromLTRB(8, 2, 0, 2),
                    title: Text("Anonymous"+ index.toString() ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    subtitle:Text(ReviewList[index].title.length>40 ?"${ReviewList[index].substring(0,50)}...":ReviewList[index],style: TextStyle(fontSize: 12),),
                    leading: Image.asset("images/user_icon.jpg"),
                    trailing: Text(/*widget.query.review_ratings*/""),
                  ) ),



            ],
          ),
        ),
      ),
    );
  }
}
