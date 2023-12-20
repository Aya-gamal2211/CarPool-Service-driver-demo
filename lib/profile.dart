import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseSQL.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  int _selectedIndex = 0; // Added default value for selectedIndex
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



  String ?email;

  void readData() async{
    String UID=currentUser!.uid;
    String query="SELECT * FROM USERS WHERE UID = '$UID'";
    var response=await myDB.reading(query);
    userRow=response[0];
    fname=userRow?['FNAME'].toString();
    lname=userRow?['LNAME'].toString();
    setState(() {
      fname=userRow?['FNAME'].toString();
      lname=userRow?['LNAME'].toString();
      mobile =userRow?['Mobile'].toString();
    });

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
                Navigator.pushNamed(context, '/Profile');
              },
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, '/rides');
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
                Navigator.pushNamed(context, '/addRide');
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
