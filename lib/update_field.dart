import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connection/retrive_data.dart';
import 'package:firebase_connection/users_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class UpdateField extends StatefulWidget {
  UpdateField({this.model,Key? key}) : super(key: key);

  users_model? model;

  @override
  _UpdateFieldState createState() => _UpdateFieldState();
}

class _UpdateFieldState extends State<UpdateField> {
  final fName = TextEditingController();
  final sName = TextEditingController();
  final address = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final imageURL = TextEditingController();
  late double width;
  late double height;


  @override
  void initState() {

    if(widget.model != null){
      fName.text = (widget.model!.f_name);
      sName.text = widget.model!.s_name;
      address.text = widget.model!.address;
      phoneNo.text = widget.model!.phone_no;
      email.text = widget.model!.email;
      pass.text = widget.model!.pass;
    }

    print(widget.model);
    super.initState();
  }


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


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          title: const Text('Update User Data',),

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
                  const Text('Update User Data ',
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

                ],
              ),

              ElevatedButton(
                  onPressed: () async {
                    if(validateData()) {
                      update_fields();
                      clear_fun();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const LoadDataFromFirestore()),
                      );
                      await showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: new Text('Update Data'),
                              content: const Text(
                                  'Data Updated Successfully '),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: const Text('Check Data',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),),
                                ),
                              ],
                            ),
                      );
                    }
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
                  child: Text("update Data")),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoadDataFromFirestore()),
                    );
                  }, child: Text('Check Data')),
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

  update_fields() async {

    CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final userID = FirebaseAuth.instance.currentUser!.uid;
    users_model model = users_model (fName.text,sName.text,address.text,phoneNo.text,email.text,pass.text,this.imageURL.text);
    try{
      await users.doc(userID).set(
          model.toJson()
      );
    }
    on FirebaseAuthException catch(e){
      print(e.toString());

    }

  }



}
