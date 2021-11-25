import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connection/users_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoadDataFromFirestore extends StatefulWidget {
  const LoadDataFromFirestore({Key? key}) : super(key: key);

  @override
  _LoadDataFromFirestoreState createState() => _LoadDataFromFirestoreState();
}


class _LoadDataFromFirestoreState extends State<LoadDataFromFirestore> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieved Data From Firebase',style: TextStyle(fontSize: 15),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const CircularProgressIndicator();
          }

          List<users_model> list = [];
          for (var element in snapshot.data!.docs) {
            if(element.exists && element.data() != null){
              var model = users_model.fromMap(element.data() as Map<String, dynamic>);
              list.add(model);
            }

          }
          return ListView.builder(

            itemBuilder: (ctx,i){
              var model = list[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(

                    color:(i%2==0) ?Colors.tealAccent : Colors.lightGreenAccent,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text(model.f_name+"\'s  detail", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
                        Text("First Name : " + model.f_name,),
                        Text("Last Name : " + model.s_name),
                        Text("Address : " + model.address),
                        Text("Phone No : " + model.phone_no),
                        Text("Email : " + model.email),


                      ],

                    ),


                  ),

                  const SizedBox(height: 20,),
                ],
              );
            },

            itemCount: list.length,

          );

        },
      ),
    );
  }
  }









