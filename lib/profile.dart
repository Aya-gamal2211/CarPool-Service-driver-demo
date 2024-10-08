import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseSQL.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser=FirebaseAuth.instance.currentUser;

  Database2 myDB= Database2();
  Map <String,dynamic> ?userRow;
  String? fname;
  String? lname;
  String? mobile;
  signOut() async {
    await auth.signOut();
  }

  User? currentuser=FirebaseAuth.instance.currentUser;

  String ?email;
  FirebaseFirestore firestore=FirebaseFirestore .instance;

  void readData() async{
    try{
      String UID=currentuser!.uid;
      if (UID != null) {
        String query="SELECT * FROM USERS WHERE UID = '$UID'";
        var response=await myDB.reading(query);
        print("Database response: $response");
        if(response.isNotEmpty) {
          userRow = response[0];
          fname = userRow?['FNAME'].toString();
          lname = userRow?['LNAME'].toString();
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult != ConnectivityResult.none) {
            firestore.collection('users').doc(currentuser!.uid).update({
              'firstName': fname,
              'lastName': lname,
              'phone': userRow?['Mobile'].toString(),
            });
            // }
            setState(() {
              fname = userRow?['FNAME'].toString();
              lname = userRow?['LNAME'].toString();
              mobile = userRow?['Mobile'].toString();
            });
          }
        }
        else{
          print('User data not found');
        }
      } else {
        print('Current user is null');
      }
    } catch (e) {
      print('Error reading data: $e');
      // Handle the error as needed
    }
  }
  // User is signed in



  @override
  void initState(){
    readData();

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
            Text('$fname $lname',
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(

            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/Profile');
              },
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/rides');
              },
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/ManageAccount');
              },
            ),
            label: 'Manage Account',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon:Icon(Icons.car_crash_outlined),

              onPressed: () {
                Navigator.pushReplacementNamed(context, '/addRide');
              },
            ),
            label: 'Rides',
          ),

        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
      ),
    );
  }
}
