





import 'package:driver_demo/rides.dart';
import 'package:driver_demo/signUp.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'addRide.dart';
import 'signUp.dart';
import 'manageAccount.dart';
import 'profile.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    title: 'Car Pool',
    home:SignIn(),
    routes: {
    '/rides':(context)=>RideOfferScreen(),
      '/addRide':(context)=>AddRide(),
      '/SignUp':(context)=>SignUp(),
      '/ManageAccount':(context)=>ManageAccount(),
      '/Profile':(context)=> Profile(),
    },
  ));
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _signinkey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "ASU CarPool",
          textAlign: TextAlign.left,
        ),
      ),
      body: Form(
        key: _signinkey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [

              Container(
                height: 150,
                width: 150,
                child: Image.asset('assets/driver.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: mailController,
                  decoration: InputDecoration(
                    hintText: "Enter email or phone number",
                    prefixIcon: Icon(Icons.mail),

                  ),
                  validator:(value){
                    if (value == null || value.isEmpty)
                      return 'Please enter your mail';
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.password_outlined),
                  ),
                  validator:(value){
                    if (value==null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignUp');
                    },
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: ()
                //   {
                //   if (_signinkey.currentState?.validate() ?? false) {
                //     // Validation passed, perform sign-in logic here
                //     Navigator.pushNamed(context, '/Reservation');
                //   }
                // }
                async {
                  if (_signinkey.currentState?.validate() ?? false) {
                    try {
                      final user=await _auth.signInWithEmailAndPassword(
                        email: mailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      if (user != null) {
                        print("successfully LoggedIn");
                        // Sign in successful, navigate to the next screen
                        Navigator.pushNamed(context, '/addRide', arguments:{
                          'mail':mailController.text,
                        });
                      }
                    } catch (e) {
                      // Handle sign-in errors, e.g., display an error message
                      print('Error signing in: $e');

                    }
                  }
                },
                child: Text("Sign in"),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

