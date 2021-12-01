import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteUser {
  deleteUser(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, var i) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.data!.docs[i].reference);
    });
  }

   deleteUserDialog( BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot, var i, String f_name ) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(

           title: const Text("Alert Dialog"),
           content: Text("Are You Sure To Delete $f_name..!!!"),
           actions: [
             FlatButton(
               child: Text("Delete $f_name "),
               onPressed: () {
                 deleteUser(snapshot,i);
                 Navigator.of(context).pop();
               },
             )
           ],
         );
       },

     );
   }

}





