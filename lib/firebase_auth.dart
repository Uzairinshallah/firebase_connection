import 'package:firebase_connection/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class MyApp_f extends StatefulWidget {
   const MyApp_f({Key? key}) : super(key: key);

  @override
  _MyApp_fState createState() => _MyApp_fState();
}

class _MyApp_fState extends State<MyApp_f> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  //final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final google = GoogleSignIn();
  GoogleSignInAccount? google_user;

  @override
  Widget build(BuildContext context) {
    //User? user = FirebaseAuth.instance.currentUser;
    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('User Authentication Firebase',)),
          //title: Text('Auth User(Logged '+(user == null ? 'out':'in')+')'),
        ),
        body: SingleChildScrollView(
          // padding: EdgeInsets.all(4),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(
                    'https://cdn.pixabay.com/photo/2021/08/25/12/45/phishing-6573326__340.png',
                    fit: BoxFit.fill,
                ),
              ),
              SizedBox(height:35),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(

                    hintStyle: TextStyle(fontSize: 12),
                    hintText: 'Enter your email please',
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    icon: IconButton(onPressed: () {  }, icon: Icon(Icons.email),

                    )
                  ),
                ),
              ),

              SizedBox(height: 20,),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 12),
                      hintText: 'Enter your password please',
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      icon: IconButton(onPressed: () {  }, icon: Icon(Icons.password),

                      )
                  ),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ElevatedButton(child: const Text('Sign Up'),
                    onPressed: () async{
                    try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );}
                      on FirebaseAuthException catch(e)
                      {
                        print(e.toString());
                      }

                      setState(() {
                      });
                    },),
                  ElevatedButton(child: const Text('Sign In'),
                    onPressed:() async{
                    try{
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => loggedin()),
                          );

                      // setState(() {
                      //
                      // });

                    }
                    on Exception catch(e)
                      {
                        print(e.toString());
                      }

                    },

                  ),
                  //SizedBox(width: 40,),
                  ElevatedButton(child: const Text('Log Out'),
                    onPressed: () async{
                      await FirebaseAuth.instance.signOut();
                      setState(() {

                      });

                    },
                  ),

                  SizedBox(height: 40,),
                ],
              ),
              SizedBox(height: 5,),

              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('Signin with google'),
                onPressed: () async{
                  try{
                    google.signOut();
                    final googleMethod = await google.signIn();
                    google_user = googleMethod;
                    final auth = await googleMethod!.authentication;
                    final cred = GoogleAuthProvider.credential(
                        accessToken: auth.idToken,idToken: auth.idToken
                    );
                    await FirebaseAuth.instance.signInWithCredential(cred).whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loggedin()),
                      );
                      // print (google_user!.email.toString());
                      // print (google_user!.displayName.toString());
                      // print (google_user!.photoUrl.toString());

                    });
                  }
                  catch(e){
                    //print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}
