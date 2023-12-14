import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Authenticate{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkUserExistsInFirestore(String email, String password) async {
    // Ensure your Firestore query is correctly checking for user existence

    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return query.docs.isNotEmpty; // Returns true if there are documents matching the email
    } catch (e) {
      // Handle any potential errors during the Firestore query
      print('Error checking user existence: $e');
      return false;
    }
  }

  //Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password ,String firstName, String LastName ,String phone) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:email,
          password:password
      );
      String UID=userCredential.user!.uid;

      // await mydb.write(''' INSERT INTO 'USERS' ('UID','FNAME','LNAME') VALUES ('$UID',' ${_fNameController.text}','${_lNameController.text}') ''' );
      if (userCredential != null) {
        await saveUserData(UID, email,firstName,LastName,phone); // Save user data to Firestore
      }
    }
    on FirebaseAuthException catch (e) {
      print(e);
    }

    catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  Future<void> saveUserData(String Uid, String email, String FirstName, String LastName ,String phone) async {

    try {
      await FirebaseFirestore.instance.collection('driver').doc(Uid).set({
        'firstName':FirstName,
        'lastName':LastName,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      print('Error saving user data: $e');
      // Handle data saving errors here.
    }
  }


}