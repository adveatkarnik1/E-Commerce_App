import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/SideMenu.dart';
import 'package:ecommerce_app/model.dart';
import 'package:ecommerce_app/models/auth_user.dart';
import 'package:ecommerce_app/svd_recommended_provider.dart';
import 'package:ecommerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/SearchPage.dart';

import '../details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  final user = const AuthUser(true);
  final newUser = const AuthUser(false);
  GlobalKey<ScaffoldState> _drawerKey =GlobalKey();
  List nav_items=["Electronics","Home","Beauty","Mobile","Appliances","Toys"];
  @override
  Widget build(BuildContext context) {
    final recommender = Provider.of<SVDRecommendedProvider>(context);
    final areProductsRecommended = recommender.areProductsBeingRecommended();

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black26,
                    boxShadow: [BoxShadow(color: Colors.white10.withOpacity(0.2),spreadRadius: 0.2)]
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          _drawerKey.currentState!.openDrawer();
                        }, icon: Icon(Icons.menu,color: Colors.white,)),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                          },
                          child: Container(
                            height: 55,
                            width: 200,
                            decoration: BoxDecoration(
                              //border: Border.all(color: Colors.white)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Search Products...",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 12),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: (){}, child: Icon(Icons.shopping_cart_rounded,color: Colors.white,),
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.1)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              )
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black87,
                        )

                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: nav_items.length,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: ()
                        {
                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>Category(query: nav_items[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:Center(
                            child: Text(nav_items[index],style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      );
                    }),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('products').limit(10).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final products = snapshot.data!.docs;
                  return Column(
                    children: [
                      CarouselSlider(items:products.map((item)
                      {
                        final querymodel= Model.fromQuery(item
                        as QueryDocumentSnapshot<Map<String, dynamic>>);

                        return Builder(builder: (BuildContext context){
                          try{
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=>Details(query: querymodel)));
                                },
                                child: Card(
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(querymodel.img,
                                              fit: BoxFit.cover,
                                              width:double.infinity,
                                              height:400),
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child:Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black12.withOpacity(0.1),
                                                        Colors.black87,
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end:  Alignment.bottomCenter
                                                  )
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                              child: Text(querymodel.title,style: TextStyle(fontSize: 7,color: Colors.white),),)
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            );
                          }catch(e){print(e);return Container();}
                        });
                      }).toList() , options: CarouselOptions(
                        height: 400,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ), ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                            child: Row(
                              mainAxisAlignment:  MainAxisAlignment.start,
                              children: [
                                Text("LATEST PRODUCTS",style:TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                           Container(
                            child: GridView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: 10,gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(mainAxisExtent: 300,maxCrossAxisExtent: 200
                                ,crossAxisSpacing: 11
                                ,mainAxisSpacing: 11), itemBuilder: (BuildContext context,int index){
                              final product= products[index];
                              final querymodel= Model.fromQuery(product
                              as QueryDocumentSnapshot<Map<String, dynamic>>);
                              try{
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(query:querymodel)));
                                    },
                                    child:Card(
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child:
                                              Image.network(querymodel.img,
                                                  fit: BoxFit.cover,
                                                  width:double.infinity,
                                                  height:300),
                                            ),
                                            Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child:Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black87.withOpacity(0.7),
                                                  ),
                                                  padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(querymodel.title.length>30 ? "${querymodel.title.substring(0,30 )}....":querymodel.title,style: TextStyle(color: Colors.white,fontSize: 13),),
                                                      //Text("Rs ${modellist[index].price}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w700),)
                                                      //Text(modellist[index].des.length>50 ? "${modellist[index].des.substring(0,55 )}....":modellist[index].des,style: TextStyle(color: Colors.white70,fontSize: 7),),
                                                    ],
                                                  ),)
                                            ),

                                            Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child:Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.1),
                                                  ),
                                                  padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 38,),
                                                      //Text(modellist[index].title.length>30 ? "${modellist[index].title.substring(0,30 )}....":modellist[index].title,style: TextStyle(color: Colors.white,fontSize: 13),),
                                                      Text("Rs ${querymodel.price}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w700),)
                                                      //Text(modellist[index].des.length>50 ? "${modellist[index].des.substring(0,55 )}....":modellist[index].des,style: TextStyle(color: Colors.white70,fontSize: 7),),
                                                    ],
                                                  ),)
                                            ),
                                            Positioned(

                                              top: 0,
                                              right:0,
                                              child:Container(
                                                  decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.black87.withOpacity(0.5)
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(querymodel.ratings.toString() , style: TextStyle(fontSize: 13,color: Colors.white),),
                                                      Icon(Icons.star_border_rounded,size: 15,color: Colors.white,),
                                                    ],
                                                  )
                                              ), )
                                          ],
                                        )
                                    ),),
                                );
                              }catch(e){print(e);return Container();}
                            }) ,
                          ),
                           Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed: (){
                                  //Navigator.push(context, MaterialPageRoute<String>(builder: (context)=>Category(query:city)) );
                                }, child: Text("Show More",style: TextStyle(color: Colors.black),))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
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

                  return GridView.builder(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: 10,gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(mainAxisExtent: 300,maxCrossAxisExtent: 200
                      ,crossAxisSpacing: 11
                      ,mainAxisSpacing: 11), itemBuilder: (BuildContext context,int index){
                    final product= products[index];
                    final querymodel= Model.fromQuery(product
                    as QueryDocumentSnapshot<Map<String, dynamic>>);
                    try{
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(query:querymodel)));
                          },
                          child:Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child:
                                    Image.network(querymodel.img,
                                        fit: BoxFit.cover,
                                        width:double.infinity,
                                        height:300),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child:Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black87.withOpacity(0.7),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(querymodel.title.length>30 ? "${querymodel.title.substring(0,30 )}....":querymodel.title,style: TextStyle(color: Colors.white,fontSize: 13),),
                                            //Text("Rs ${modellist[index].price}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w700),)
                                            //Text(modellist[index].des.length>50 ? "${modellist[index].des.substring(0,55 )}....":modellist[index].des,style: TextStyle(color: Colors.white70,fontSize: 7),),
                                          ],
                                        ),)
                                  ),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child:Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 38,),
                                            //Text(modellist[index].title.length>30 ? "${modellist[index].title.substring(0,30 )}....":modellist[index].title,style: TextStyle(color: Colors.white,fontSize: 13),),
                                            Text("Rs ${querymodel.price}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w700),)
                                            //Text(modellist[index].des.length>50 ? "${modellist[index].des.substring(0,55 )}....":modellist[index].des,style: TextStyle(color: Colors.white70,fontSize: 7),),
                                          ],
                                        ),)
                                  ),
                                  Positioned(

                                    top: 0,
                                    right:0,
                                    child:Container(
                                        decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.black87.withOpacity(0.5)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Row(
                                          children: [
                                            Text(querymodel.ratings.toString() , style: TextStyle(fontSize: 13,color: Colors.white),),
                                            Icon(Icons.star_border_rounded,size: 15,color: Colors.white,),
                                          ],
                                        )
                                    ), )
                                ],
                              )
                          ),),
                      );
                    }catch(e){print(e);return Container();}
                  });
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
      ),
    );
  }
}
