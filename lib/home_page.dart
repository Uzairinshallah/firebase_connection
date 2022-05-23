import 'package:firebase_connection/retrive_data.dart';
import 'package:firebase_connection/users_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_connection/image_uploader.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



class loggedin extends StatefulWidget {
  loggedin( {this.model,Key? key}) : super(key: key);

  users_model? model;

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
  String? imageURL ;



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

                  Column(
                    children: [
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {

                                uploadImage();
                              },
                              child: const Text('Upload Button',style: TextStyle(color: Colors.white),),
                              color: Colors.lightBlue,
                            ),
                          ),
                          (imageURL!=null)
                          // ? Image.network(imageURL!)
                              ? Text('Image Uploaded',style: TextStyle(fontSize: 15, color:Colors.teal),)
                              :
                          Text('Image Not Uploaded Yet',style: TextStyle(fontSize: 15, color:Colors.black),),
                        ],
                      ),
                      //const Placeholder(fallbackHeight: 100.0,fallbackWidth: double.infinity,),
                      const SizedBox(height:20),

                      // getTextField("Enter Your Password", pass),
                      // GetBox(10),
                      //IMAGE URL
                      GetBox(20),

                    ],
                  ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final userId = FirebaseAuth.instance.currentUser!.uid;
                        if(validateData()){
                          FirebaseFirestore.instance.collection("users").doc(userId);
                          // print(userId);




                        await users.add({

                          'f_name': fName.text,
                          's_name': sName.text,
                          'address': address.text,
                          'phone_no': phoneNo.text,
                          'email': email.text,
                          'password': pass.text,
                          'imageURL': imageURL,

                         // widget.model!.toJson()
                        }).then((value) => clear_fun()

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
                                fontSize: 16.0,
                            );
                          }
                      },
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(

                          primary: Colors.deepPurpleAccent
                      )
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoadDataFromFirestore()),
                        );

                      },
                      child: const Text('Check Data'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent
                      )
                  ),
                ],
              ),

              GetBox(20),

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

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker  = ImagePicker();
    PickedFile image;

    //Check permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if(permissionStatus.isGranted){
      //select image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
    var file = File(image.path);
    String d =DateTime.now().microsecondsSinceEpoch.toString();
    if (image !=null){
    //upload to firebase
    var snapshot = await _storage.ref()

        .child('ProfilePics/$d')
        .putFile(file)
        .whenComplete(() => null);

    var downloadURL = await snapshot.ref.getDownloadURL();

    setState(() {
    imageURL = downloadURL;
    });

    }else{
    print('No Path Recieved');
    }

    }
    else{
    print('Grant permission and try again');
    }
  }
}
