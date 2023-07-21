import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule1/pages/profile.dart';


class Mydrawer extends StatefulWidget{
  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore ref = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context)  {


    return Drawer(

      child:Container(
        color: Colors.black12,
        child: ListView(
          padding:EdgeInsets.zero,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: ref.collection("users").doc(_auth.currentUser!.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  final data1= snapshot.data!["username"];
                  final data2=snapshot.data!['email'];

                  return head(data1, data2);
                }
            ),






            ListTile(
              leading: Icon(CupertinoIcons.home,
                color: Colors.black,
              ),
              title: Text("Home",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.black,
                ),),
            ),
            GestureDetector(
              onTap:()=>{
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) => ProfilePage())),
              },
              child: ListTile(
                leading: Icon(CupertinoIcons.profile_circled,
                  color: Colors.black,
                ),
                title: Text("Profile",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout,
                color: Colors.black,
              ),
              title: Text("Log out",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.black,
                ),),
            )
          ],
        ),
      ),
    );



  }
  Widget head( String data1,String data2){
   return  DrawerHeader(
      padding: EdgeInsets.zero,
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Colors.brown),
        margin:EdgeInsets.zero,

        accountName: Text(data1),
        accountEmail: Text(data2),
        currentAccountPicture: CircleAvatar(
          backgroundImage:AssetImage('assets/images/acc.no.png'),
        ),

      ),
    );
  }
}