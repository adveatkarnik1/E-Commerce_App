import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'model.dart';
class Address extends StatefulWidget {
  Model query = new Model(img: "", id: "");
  Address({required this.query});
  @override
  State<Address> createState() => _AddressState();
}
List<Model> products=[];
class _AddressState extends State<Address> {
  @override
  String? state;
  String? country;
  bool isSubmit=false;
  final _formKey1 = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    products.add(widget.query);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping Details",style:TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white
        )
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: ElevatedButton( style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black87),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(color: Colors.black87)))),
          onPressed: () {
          if(isSubmit==true)
            {

            }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submit the shipping details')),
                );
              }
            // Validate returns true if the form is valid, or false otherwise.
          },
          child: const Text('Pay',style: TextStyle(color: Colors.white,fontSize: 20),),
        ),
      ),
      body:
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Container(
                 padding: EdgeInsets.all(8),
                   child: Text("Product details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                SizedBox(height: 2,),
               Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder:(context,index)=>ListTile(
                        hoverColor: Colors.black54,
                        contentPadding: EdgeInsets.fromLTRB(8, 2, 0, 2),
                        title: Text(products[index].title.length>18 ?"${products[index].title.substring(0,15)}...":products[index].title,style: TextStyle(fontSize: 15),),
                        subtitle:Text("${products[index].price}Rs" ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                        leading: Image.network(products[index].img),
                        trailing: IconButton(
                          icon: Icon(Icons.delete), onPressed: () {
                            setState(() {
                              products.removeAt(index);
                              if(products.length==0)
                                {
                                  Navigator.pop(context);
                                }
                            });
                        },
                        ),

                      ) ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Customer Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                SizedBox(height: 2,),
    Container(
    child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),

    child: Form(
    key: _formKey1,
    child: Column(
    children: [
    const SizedBox(
    height: 10,
    ),



    Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
    child: TextFormField(
    decoration:   InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'FirstName',
    hintText: 'FirstName',
    //icon: Icon(Icons.person),
    isDense: true,
    ),
    validator: (val) {
    if (val!.isEmpty) {
    return 'FirstName';
    }
    return null;
    },
    ),
    ),

    const SizedBox(
    height: 10,
    ),

    Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
    child: TextFormField(
    decoration:   InputDecoration(
    border: OutlineInputBorder(),
    labelText:  'LastName',
    hintText:  'LastName',
    //icon: Icon(Icons.person),
    isDense: true,
    ),
    validator: (val) {
    if (val!.isEmpty) {
    return 'LastName';
    }
    return null;
    },
    ),
    ),
    const SizedBox(
    height: 10,
    ),

    Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
    child: TextFormField(

    decoration:   InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Email',
    hintText:  'Email',
    //icon: Icon(Icons.person),
    isDense: true,
    ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'LastName';
        }
        return null;
      },
    ),
    ),
    const SizedBox(
    height: 10,
    ),


    Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
    child: TextFormField(
    maxLength: 10,

    decoration:   InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'ContactNo',
    hintText:  'ContactNo',
    //icon: Icon(Icons.person),
    isDense: true,
    ),
    validator:
    (val) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (val!.isEmpty) {
    return 'mobile';
    } else if(val.length != 10){
    return 'Mobile';
    }else if (!regExp.hasMatch(val)) {
    return 'Mobile';
    }
    return null;
    },

    inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0.0-9.9]')),
    ],
    ),

    ),

      Container(
        margin: EdgeInsets.all(16),
        child: CountryStatePicker(
          onCountryChanged: (ct) => setState(() {
            country = ct;
            state = null;
          }),
          onStateChanged: (st) => setState(() {
            state = st;
          }),
          // A little Spanish hint
          countryHintText: "India",
          stateHintText: "Maharashtra",
          noStateFoundText: "No state found",
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: TextFormField(

          decoration:   InputDecoration(
            border: OutlineInputBorder(
            ),
            labelText: 'Address',
            hintText:  'Address',
            //icon: Icon(Icons.person),
            isDense: true,
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Address';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: TextFormField(
          maxLength: 6,

          decoration:   InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'PinCode',
            hintText:  'PinCode',
            //icon: Icon(Icons.person),
            isDense: true,
          ),
          validator:
              (val) {
            String patttern = r'(^[0-9]*$)';
            RegExp regExp = RegExp(patttern);
            if (val!.isEmpty) {
              return 'pincode';
            } else if(val.length != 6){
              return 'pincode';
            }else if (!regExp.hasMatch(val)) {
              return 'pincode';
            }
            return null;
          },

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0.0-9.9]')),
          ],
        ),

      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black)))),
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey1.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing data')),
              );
            }
            isSubmit=true;
          },
          child: const Text('Submit',style: TextStyle(color: Colors.white),),
        ),
      ),
    ],
    ),
    ),
    ),
    ),
          ],
        ),
    ),
        ),
    );
  }
}
