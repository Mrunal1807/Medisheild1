import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:schedule1/service//theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Map<String,dynamic>user;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore ref = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          toolbarHeight: 250,
          shape:
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(80),bottomRight: Radius.circular(80)),
          ),
           leading: Padding(
             padding: const EdgeInsets.only(top:0.0,bottom:180),
             child: GestureDetector(
               onTap: ()=> Navigator.pop(context),
                 child: Icon(Icons.arrow_back,color: Colors.white,)),
           ),
          title: Padding(
            padding: const EdgeInsets.only(left:70,bottom: 60),
            child: Text('Profile',style:GoogleFonts.actor(
                textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                )
            )),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: ref.collection("users").doc(_auth.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot>snapshot) {
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            final data1= snapshot.data!["username"];
            final data2=snapshot.data!['email'];
            final data3=snapshot.data!['contact no'];
            return profile(data1, data2, data3);
          }
        ),
      ),
        Positioned(
            top: 210,
            left: 120,

            child: Center(
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Icon(Icons.person,color: Colors.white,size: 120,),
            ),

          ),
        ))
      ],
    );
  }
Widget profile(String data1,String data2,String data3 ){
  return Container(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          SizedBox(height: 80.0),
          Container(

              height: 70,
              width: 380,
              // color: Colors.grey,
              margin: EdgeInsets.only(top:25.0),
              padding:EdgeInsets.only(left:50.0,right: 50.0),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(12.0 ),
                //border: Border.all(width: 10),
                boxShadow:[BoxShadow(
                  color: Colors.white10,
                  // blurRadius: 2.0,
                  offset: const Offset(5.0, 5.0),
                  // spreadRadius: 0.25,


                )],
              ),
              child: Row(

                children: [
                  Icon(Icons.person,size: 35,),
                  SizedBox(width: 30,height: 100,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("\n"+data1,style: subTitleStyle6,),
                      Text("Username",style:subTitleStyle),
                    ],
                  )
                ],
              )
          ),
          Container(

              height: 70,
              width: 380,
              // color: Colors.grey,
              margin: EdgeInsets.only(top:25.0),
              padding:EdgeInsets.only(left:50.0,right: 50.0),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(12.0 ),
                //border: Border.all(width: 10),
                boxShadow:[BoxShadow(
                  color: Colors.white10,
                  // blurRadius: 2.0,
                  offset: const Offset(5.0, 5.0),
                  // spreadRadius: 0.25,


                )],
              ),
              child: Row(

                children: [
                  Icon(Icons.email,size: 35,),
                  SizedBox(width: 30,height: 100,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("\n"+data2,style: subTitleStyle6,),
                      Text("Email Id",style:subTitleStyle),
                    ],
                  )
                ],
              )
          ),

          Container(

              height: 70,
              width: 380,
              // color: Colors.grey,
              margin: EdgeInsets.only(top:25.0),
              padding:EdgeInsets.only(left:50.0,right: 50.0),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(12.0 ),
                //border: Border.all(width: 10),
                boxShadow:[BoxShadow(
                  color: Colors.white10,
                  // blurRadius: 2.0,
                  offset: const Offset(5.0, 5.0),
                  // spreadRadius: 0.25,


                )],
              ),
              child: Row(

                children: [
                  Icon(Icons.phone,size: 35,),
                  SizedBox(width: 30,height: 100,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("\n"+data3,style: subTitleStyle6,),
                      Text("Contact number",style:subTitleStyle),
                    ],
                  )
                ],
              )
          ),
        ],
      ),
    ),
  );
}

}


