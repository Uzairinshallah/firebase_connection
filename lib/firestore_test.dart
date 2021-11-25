import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class firestore_model extends StatelessWidget {
  final Stream<QuerySnapshot> users= FirebaseFirestore.instance.collection('users').snapshots();
  firestore_model({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: users,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                    ){
                        if(snapshot.hasError){
                          return Text('Something Went Wrong');
                        }
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          Text('Loading');
                        }
                        final data = snapshot.requireData;
                        return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context,index){
                            return Text('My name is ${data.docs[index]['name']} and age is ${data.docs[index]['age']}');
                          },
                        );

            }),
          )

        ],
      ),
    );
  }
}








