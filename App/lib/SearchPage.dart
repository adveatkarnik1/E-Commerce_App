import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_outlined,color: Colors.black,),),
                    Expanded(
                      child: TextField(
                          cursorColor: Colors.black54,
                          keyboardType:  TextInputType.multiline,
                          minLines: 50,
                          maxLines: null,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Search Products....",
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 12),
                          )),
                    ),
                  ],
                ),
              ),
              /*ListView.builder(
                  itemCount: 10,
                  itemBuilder: itemBuilder)*/
            ],
          ),
        ));
  }
}
