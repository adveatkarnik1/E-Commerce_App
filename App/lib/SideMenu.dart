import 'package:ecommerce_app/constants/routes.dart';
import 'package:ecommerce_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    Widget sectionone()
    {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child:TextButton(onPressed: (){}, child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(Icons.supervised_user_circle_outlined,color: Colors.black,size: 30,),
              SizedBox(width:10,),
              Text("User",style: TextStyle(color: Colors.black,fontSize:13),),
            ],
          ),
        ),
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.5)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
              )
          ),),
      );
    }
    Widget sectionthree()
    {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child:TextButton(onPressed: (){
         // Navigator.push(context, MaterialPageRoute(builder: (context)=>ArchiveViewNote()));
        }, child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(Icons.home_outlined,color: Colors.black,size: 30,),
              SizedBox(width:10,),
              Text("Home",style: TextStyle(color: Colors.black,fontSize:13),),
            ],
          ),
        ),
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
              )
          ),),
      );
    }
    Widget sectiontwo()
    {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child:TextButton(onPressed: (){
          Navigator.of(context).pushNamed(cartScreen);
        }, child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(Icons.shopping_cart_outlined,color: Colors.black,size: 30,),
              SizedBox(width:10,),
              Text("Cart",style: TextStyle(color: Colors.black,fontSize:13),),
            ],
          ),
        ),
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
              )
          ),),
      );
    }

    void logOut() async {
      final shouldLogOut = await showLogOutDialog(context);
      if (shouldLogOut) {
        await AuthService.firebase().logout();

        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacementNamed(authenticationScreen);
      }
    }

    Widget sectionfour() {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: logOut,
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 10,),
                Text("Log Out", style: TextStyle(color: Colors.black,fontSize:13),),
              ],
            ),
          ),
        ),
      );
    }

    return Drawer(
        child:SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    child: Row(
                      children: [
                        Icon(Icons.shop,size: 30,color: Colors.black,),
                        SizedBox(width: 5,),
                        Text("Flipkart",style: TextStyle(fontSize: 20,color: Colors.black87,fontWeight: FontWeight.bold),),
                      ],
                    )),
                Divider(
                  color: Colors.black.withOpacity(0.2),
                ),
                sectionone(),
                SizedBox(height: 10,),
                sectionthree(),
                SizedBox(height: 10,),
                sectiontwo(),
                const Expanded(child: SizedBox(),),
                sectionfour(),
              ],
            ),
          ),
        )
    );
  }
}
