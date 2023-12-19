
import 'package:driver_demo/fireStore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'fireStore.dart';

class RideOfferScreen extends StatefulWidget {
  const RideOfferScreen({super.key});

  @override
  State<RideOfferScreen> createState() => _RideOfferScreen();
}

List <String> Destinations=["Gate 3", 'Gate 4'];
String Source='Faculty of Engineering Campus';

class _RideOfferScreen extends State <RideOfferScreen> {

  final Uid=FirebaseAuth.instance.currentUser!.uid;
  fireStore mydata = fireStore();

  @override
  Widget build(BuildContext context) {
    setState(() {

    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Ride Offers'),
        centerTitle: true,
      ),
      body:

      Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child:
            StreamBuilder<List<DocumentSnapshot>>(
                stream: mydata.fetchdata(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  }

                  List<DocumentSnapshot> documents = snapshot.data!;
                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var mylist = documents[index].data() as Map<String, dynamic>;
                        DocumentReference requestDoc = FirebaseFirestore.instance.collection('requests').doc(Uid);

                        Map<String, dynamic> updateData = {
                          'fromLocation': mylist['from'],
                          'toLocation': mylist['to'],
                          'date': mylist['date'], // Firestore can handle DateTime objects directly
                          // 'driver': driver_name,
                          'time':mylist['time'],
                          'price': mylist['fees'],
                          'status': 'pending',
                          'driverId':Uid,
                          // 'username':name,
                          'status': 'Pending',
                          'userId':mylist['id'],
                        };
                        return Card(
                          child: ListTile(
                              leading: Icon(Icons.car_crash_outlined,
                                color: Colors.blue,),

                              title: Column(

                                children: [
                                  // Text("Destination : ${mylist[index].data()['to']}",style: TextStyle(
                                  Text("Destination : ${mylist['to']}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                    ),),
                                  // Text("Source : ${mylist[index].data()['from']}",style: TextStyle(
                                  Text("Destination : ${mylist['from']}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                    ),),
                                ],
                              ),
                              subtitle: Column(

                                children: [
                                  // Text("Date : ${mylist[index].data()['date']}",style: TextStyle(
                                  Text("Destination : ${mylist['date']}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,),

                                  ),
                                  // Text("Time : ${mylist[index].data()['time']}",style: TextStyle(
                                  Text("Destination : ${mylist['time']}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,),
                                  ),
                                  // Text("Fees :  \$ ${mylist[index].data()['fees']}",
                                  Text("Fees :  \$ ${mylist['fees']}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,),
                                  ),
                                ],
                              )),
                        );
                      });
                }),

          ),


          ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/addRide');

            },
            child: Text('Add Ride'),
          ),
        ],
      ),

    );
  }
}


//
//
// }
// class RideOfferScreen extends StatelessWidget {
//   final fireStore mydata = fireStore();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Ride Offers'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: _buildRideList(context),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/addRide');
//             },
//             child: Text('Add Ride'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRideList(BuildContext context) {
//     return FutureBuilder(
//       future: mydata.fetchdata(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List mylist = snapshot.data!;
//           return ListView.builder(
//             itemCount: mylist.length,
//             itemBuilder: (context, index) {
//               return _buildRideCard(mylist[index].data());
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
//
//   Widget _buildRideCard(Map<String, dynamic> rideData) {
//     return Card(
//       child: ListTile(
//         leading: Icon(Icons.car_crash_outlined, color: Colors.blue),
//         title: Column(
//           children: [
//             Text("Destination: ${rideData['to']}",
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//             Text("Source: ${rideData['from']}",
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           children: [
//             Text("Date: ${rideData['date']}",
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//             Text("Time: ${rideData['time']}",
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//             Text("Fees: \$${rideData['fees']}",
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
