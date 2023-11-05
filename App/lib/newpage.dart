import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'details.dart';
import 'model.dart';
class NewPage extends StatefulWidget {
  late String query;
 NewPage({required this.query});

  @override
  State<NewPage> createState() => _NewPageState();
}


class _NewPageState extends State<NewPage> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('products').where('product_sub_catagory', isEqualTo: widget.query).limit(20).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final products = snapshot.data!.docs;
                  return Column(
                    children: [
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
                          SizedBox(height: 20,),
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
                        ],
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
