import 'package:firebase_connection/retrive_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


GlobalKey globelKey = GlobalKey();


class loggedin extends StatefulWidget {
  const loggedin({Key? key}) : super(key: key);

  @override
  _loggedinState createState() => _loggedinState();
}

class _loggedinState extends State<loggedin> {
  final fName = TextEditingController();
  final sName = TextEditingController();
  final address = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  late double width;
  late double height;


  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .width;

    CollectionReference users =
    FirebaseFirestore.instance.collection('users');

    return MaterialApp(
      home: Scaffold(
        key: globelKey,
        appBar: AppBar(

          title: const Text('Sign Up Form',),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 2,
                width: width / 1.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2019/01/16/19/14/membership-3936563_960_720.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              GetBox(20),
              const Text('Sign Up Here ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              GetBox(20),
              getTextField("Enter Your First Name", fName),
              GetBox(10),
              getTextField("Enter Your Last Name", sName),
              GetBox(10),
              getTextField("Enter Your Address ", address),
              GetBox(10),
              getTextField("Enter Your Phone No", phoneNo),
              GetBox(10),
              getTextField("Enter Your Email Address", email),
              GetBox(10),
              getTextField("Enter Your Password", pass),
              GetBox(20),
              ElevatedButton(
                  onPressed: () async {
                    if(validateData()){
                    await users.add({
                      'f_name': fName.text,
                      's_name': sName.text,
                      'address': address.text,
                      'phone_no': phoneNo.text,
                      'email': email.text,
                      'password': pass.text,
                    }).then((value) => clear_fun()

                    // {fName.clear();
                    // sName.clear;}
                    );}
                    else
                      {
                        Fluttertoast.showToast(
                            msg: "Please Enter All Fields Correctly",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }



                  },
                  child: const Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme
                          .of(context)
                          .primaryColor
                  )
              ),
              GetBox(20),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoadDataFromFirestore()),
                    );
                  },
                  child: const Text('Check Data'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme
                          .of(context)
                          .primaryColor
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget GetBox(double height) {
    return SizedBox(height: height,);
  }

  Widget getTextField(String hintText,
      TextEditingController textEditingController) {
    return Center(
      child: SizedBox(

        width: width / 1.2,
        height: height * 0.093,

        child: TextFormField(

          controller: textEditingController,
          validator: (textEditingController){
            if(textEditingController!.isEmpty)
              {
                return "Please Enter Something";
              }
      },
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
          ),
          style: const TextStyle(fontSize: 15),

        ),),
    );
  }

  clear_fun() {
    fName.clear();
    sName.clear();
    address.clear();
    phoneNo.clear();
    email.clear();
    pass.clear();
  }

  bool validateData() {
    if(fName.text.isNotEmpty && sName.text.isNotEmpty && address.text.isNotEmpty &&phoneNo.text.isNotEmpty &&email.text.isNotEmpty ){
      return true;
    }
    else{
      return false;

    }
  }
}
