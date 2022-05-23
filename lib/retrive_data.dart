import 'package:firebase_connection/home_page.dart';
import 'package:firebase_connection/update_field.dart';
import 'package:firebase_connection/update_user_class.dart';
import 'package:firebase_connection/users_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'delete_user_class.dart';

class LoadDataFromFirestore extends StatefulWidget {
  const LoadDataFromFirestore({Key? key}) : super(key: key);

  @override
  _LoadDataFromFirestoreState createState() => _LoadDataFromFirestoreState();
}

class _LoadDataFromFirestoreState extends State<LoadDataFromFirestore> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Retrieved Data From Firebase',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<users_model> list = [];
          for (var element in snapshot.data!.docs) {
            if (element.exists && element.data() != null) {
              var model =
                  users_model.fromMap(element.data() as Map<String, dynamic>);
              list.add(model);
            }
          }
          return ListView.builder(
            itemBuilder: (ctx, i) {
              var model = list[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (i == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2018/09/27/11/32/laptop-3706810__340.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      SizedBox(
                        width: width,
                        child: Container(
                          color: (i % 2 == 0)
                              ? Colors.tealAccent
                              : Colors.lightGreenAccent,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                               Card(

                                 elevation: 10,
                                 shadowColor: Colors.redAccent,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(25.0),
                                 ),
                                 margin: EdgeInsets.all(3),

                                 child: ListTile(
                                 
                                   leading: (model.imageURL!=null)?
                                     CircleAvatar(
                                       backgroundImage: NetworkImage(model.imageURL.toString() ),
                                     )
                                     :
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249__340.png'),
                                       ),


                                     title:Text(model.f_name +' '+ model.s_name),
                                   subtitle: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(model.email),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           RaisedButton(
                                             onPressed: () async {
                                               DeleteUser().deleteUserDialog(
                                                   context, snapshot, i, model.f_name);
                                             },
                                             child: const Text('Delete'),
                                           ),
                                           InkWell(
                                             onTap: () {
                                               Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                                 return UpdateField(
                                                   model: model,
                                                 );
                                               }
                                               )
                                               );
                                             },
                                             child: RaisedButton(
                                               onPressed: () {
                                                 Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                                   return UpdateField(
                                                     model: model,
                                                   );
                                                 }
                                                 )
                                                 );

                                               },
                                               child: const Text('Update'),
                                             ),
                                           ),
                                           RaisedButton(

                                             onPressed: () async {
                                               await showDialog(
                                                 context: context,
                                                 builder: (context) => AlertDialog(
                                                   title: new Text('User Details'),
                                                   content:  SizedBox(
                                                     height: height/4,
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text('First Name : ' + model.f_name),
                                                         Text('Last Name : ' + model.s_name),
                                                         Text('Email : ' + model.email),
                                                         Text('Address : ' + model.address),
                                                         Text('Phone No : ' + model.phone_no),
                                                       ],
                                                     ),
                                                   ),
                                                   actions: <Widget>[
                                                     FlatButton(
                                                       onPressed: () {
                                                         Navigator.of(context, rootNavigator: true)
                                                             .pop(); // dismisses only the dialog and returns nothing
                                                       },
                                                       child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                     ),
                                                   ],
                                                 ),
                                               );

                                             },
                                             child: const Text('View'),
                                           ),

                                         ],
                                       )
                                     ],
                                   )
                              ),
                               ),
                              // Text(
                              //   "First Name : " + model.f_name,
                              // ),
                              // Text("Last Name : " + model.s_name),
                              // Text("Address : " + model.address),
                              // Text("Phone No : " + model.phone_no),
                              // Text("Email : " + model.email),
                              Container(
                                color: Colors.white,
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
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
