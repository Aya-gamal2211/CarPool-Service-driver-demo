
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'DatabaseSQL.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});



  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fNameController=TextEditingController();
  TextEditingController _lNameController=TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _confirmMobileController=TextEditingController();
  GlobalKey <FormState> _formKey= GlobalKey();
  // FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _validateName(String value) {
    return RegExp(r"^[a-zA-Z]+$").hasMatch(value);
  }
  bool _validateEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9._]+@eng\.asu\.edu\.eg$").hasMatch(value);
  }
  bool _validatePassword(String value) {
    return value.length >= 8;
  }
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Registration logic here
      try {
        Authenticate auth=Authenticate();
        await auth.signUpWithEmailAndPassword(_emailController.text, _passwordController.text, _fNameController.text,_lNameController.text, _confirmMobileController.text);
      }
      on FirebaseAuthException catch (e) {
        print(e);
      }
      print("Form is valid. Proceed with registration.");

    } else {
      print("Form is not valid.");
    }

  }

  void _showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 2),
// Adjust the duration as needed
      action:SnackBarAction( label:'Undo',
        onPressed: (){},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void _handleSignUp() {
    // Implement your signup logic here
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String mobile= _confirmMobileController.text;
    String fname= _fNameController.text;
    String lname= _lNameController.text;
    // Validate input
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || fname.isEmpty || lname.isEmpty) {
      // Show an error message or toast
      _showErrorSnackBar("Please fill in the empty fields");

      return;
    }

    if (password != confirmPassword) {
      // Show password mismatch error
      _showErrorSnackBar("Password mismatch");
      return ;
    }



    // Implement your signup API call or authentication logic here

    // For now, print the input
    print('Email: $email, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children:[
              SizedBox(height: 32.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(

                    controller: _fNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(

                    controller: _lNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(

                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16.0),


                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _confirmMobileController,
                    decoration: InputDecoration(labelText: 'Add Mobile Number'),

                  ),

                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: ()async{

                      _handleSignUp();
                   await _register();
                      _auth.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),

                      );

                      final UID= FirebaseAuth.instance.currentUser?.uid;
                      DocumentReference docRef = firestore.collection('requests').doc(UID);
                      docRef.get().then((docSnapshot) {
                        // Check if the document exists
                        if (!docSnapshot.exists) {
                          // If the document does not exist, create it with an empty list
                          docRef.set({'Requests': []});
                        }
                      });;
                      Navigator.pushReplacementNamed(context, '/SignIn');
    },


                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
