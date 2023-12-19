import 'package:driver_demo/fireStore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fireStore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  int _selectedIndex = 0; // Added default value for selectedIndex
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser=FirebaseAuth.instance.currentUser;


  signOut() async {
    await auth.signOut();
  }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   switch (index) {
  //     case 0:
  //     // Navigate to Home page
  //       Navigator.pushNamed(context, '/Profile');
  //       break;
  //     case 1:
  //     // Navigate to Activity page
  //     // Replace '/ActivityPage' with the actual route for your Activity page
  //       Navigator.pushNamed(context, '/rides');
  //       break;
  //     case 2:
  //     // Navigate to Manage Account page
  //     // Replace '/ManageAccountPage' with the actual route for your Manage Account page
  //       Navigator.pushNamed(context, '/ManageAccount');
  //       break;
  //   }
  // }



  // User is signed in

String ?fname;
  String? lname;
  String? mobile;

  Future <void> FetchUser() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance.collection('driver').doc(
        userID).get();
    Map<String,dynamic>? data=snapshot as Map<String, dynamic>?;
    fname=data!['firstName'];
    lname=data!['lastName'];
    mobile=data!['phone'];


  }



  @override
  void initState() {
    FetchUser();
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              // You can load the user's profile picture here
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('${fname} ${lname}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(

                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Icon(Icons.star_rate_rounded),Icon(Icons.star_rate_rounded),Icon(Icons.star_rate_rounded),Icon(Icons.star_rate_rounded)
                ]),
            SizedBox(height: 15),

            Text(
              '${mobile}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the logout functionality
                // For example, you can navigate to the login page
                signOut();

                Navigator.pushNamed(context, '/SignIn');
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Profile',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: 'Activity',
      //
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Manage Account',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
