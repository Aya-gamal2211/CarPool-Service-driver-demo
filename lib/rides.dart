
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



  Future<void> updateRideStatusInHistory(Map<String, dynamic> rideToUpdate, String newStatus) async {
    var historyDocRef = FirebaseFirestore.instance.collection('history').doc(rideToUpdate['user']);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var historySnapshot = await transaction.get(historyDocRef);

      if (historySnapshot.exists && historySnapshot.data()!.containsKey('History')) {
        var historyData = historySnapshot.data();
        var historyArray = List<Map<String, dynamic>>.from(historyData!['History']);

        // Find the index of the ride to update
        var index = historyArray.indexWhere((ride) =>

            ride['rideID'] == rideToUpdate['rideID']

        );

        // If found, update the status of the ride
        if (index != -1) {
          historyArray[index]['status'] = newStatus;
        } else {
          // Handle the case where the ride is not found
          print("Ride not found in history.");
          return;
        }

        // Write the updated history array back to Firestore
        transaction.set(historyDocRef, {'History': historyArray}, SetOptions(merge: true));
      } else {
        // Handle the case where the History key doesn't exist, or the document doesn't exist
        print("No history found for this user.");
      }
    }).catchError((error) {
      print("Error updating ride status in history: $error");
    });
  }



  Stream<List<Map<String, dynamic>>> fetchrequests() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Stream.value(
          []); // Return an empty stream if the user is not logged in
    }

    // Listen for real-time updates in the 'requests' document for the current user
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(Uid)
        .snapshots()
        .map<List<Map<String, dynamic>>>((requestSnapshot) {
      if (!requestSnapshot.exists ||
          !requestSnapshot.data()!.containsKey('Requests')) {
        return [
        ]; // Return an empty list if the document or key 'Requests' does not exist
      }

      List<dynamic> requestsArray = requestSnapshot.get('Requests');
      // Transform the dynamic list to a list of maps
      return requestsArray.map<Map<String, dynamic>>((requestItem) {
        return {
          'from': requestItem['from'],
          'to': requestItem['to'],
          'date': requestItem['date'], // Firestore can handle DateTime objects directly
          // 'driver': driver_name,
          'time':requestItem['time'],
          'fees': requestItem['fees'],
          'user':requestItem['user'],
          'status': requestItem['status'],
          'driverId':requestItem['driverId'],
          'rideID':requestItem['rideID'],
        };
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
    });

    return Scaffold(
    appBar: AppBar(
    title: Text('Available Routes'),
    ),
    body:
    StreamBuilder<List<Map<String,dynamic>>>(
      // stream: FirebaseFirestore.instance
      //     .collection('requests')
      //     .doc(Uid)
      //     .snapshots(),
      stream: fetchrequests(),
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

        List<Map<String, dynamic>> requests = snapshot.data!;
         // var requests=snapshot.data!;
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            var request = requests[index] ;
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'From: ${request['from']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To: ${request['to']}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${request['date']}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: ${request['time']}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      'Price : ${request['fees']}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[


                        ElevatedButton(

                          child: Text('Accept'),

                          onPressed: () async {
                            String dateString = request['date']; // Example date-time from screenshot
                            String timeString = request['time']; // Example time in 12-hour format

// Extract the date part from the dateTimeString
//                       String dateString = dateTimeString.split("T")[0]; // "2023-12-13"

// Convert 12-hour format time to 24-hour format
                            int hour = int.parse(timeString.split(":")[0]);
                            int minute = int.parse(
                                timeString.split(":")[1].split(" ")[0]);
                            String amPm = timeString.split(" ")[1];
                            if (amPm == "PM" && hour != 12) {
                              hour = hour + 12;
                            } else if (amPm == "AM" && hour == 12) {
                              hour = 0;
                            }

// Combine date and time into a single DateTime object
                            DateTime rideDateTime = DateTime(
                                int.parse(dateString.split("-")[0]), // Year
                                int.parse(dateString.split("-")[1]), // Month
                                int.parse(dateString.split("-")[2]), // Day
                                hour,
                                minute
                            );

                            // print(rideDateTime);

// Determine cutoff DateTime
                            DateTime cutoff = DateTime.now();
                            if (rideDateTime.hour == 7 && rideDateTime.minute == 30) { // Morning ride
                              cutoff = DateTime(rideDateTime.year, rideDateTime.month, rideDateTime.day, 23, 30).subtract(Duration(days: 1));
                            } else if (rideDateTime.hour == 17 && rideDateTime.minute == 30) { // Evening ride
                              cutoff = DateTime(rideDateTime.year, rideDateTime.month, rideDateTime.day, 16, 30);
                            } else {
                              // Handle other cases or set a default cutoff
                            }

                            // Check if current time is after the cutoff
                            if (DateTime.now().isAfter(cutoff)) {
                              // Show message that the cutoff time has passed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Time Passed 🤦‍"),
                                    content: Text(
                                        "Unfortunately, The Time to accept this trip has passed 😢"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                           else {
                              try {
                                await FirebaseFirestore.instance.collection(
                                    'requests').doc(Uid).update({
                                  'Requests': FieldValue.arrayRemove([request])
                                });
                                print('Update successful!');
                              } catch (e) {
                                print('Error updating Firestore: $e');
                              }
                              updateRideStatusInHistory(request, "Accepted 👍");
                            }
                          },
                            style:
                            ElevatedButton.styleFrom(primary: Colors.blue)


                        ),
                        SizedBox(width: 8),
                        OutlinedButton(
                          child: Text('Reject'),
                          onPressed: () async {
                            String dateString = request['date']; // Example date-time from screenshot
                            String timeString = request['time']; // Example time in 12-hour format

// Extract the date part from the dateTimeString
//                       String dateString = dateTimeString.split("T")[0]; // "2023-12-13"

// Convert 12-hour format time to 24-hour format
                            int hour = int.parse(timeString.split(":")[0]);
                            int minute = int.parse(
                                timeString.split(":")[1].split(" ")[0]);
                            String amPm = timeString.split(" ")[1];
                            if (amPm == "PM" && hour != 12) {
                              hour = hour + 12;
                            } else if (amPm == "AM" && hour == 12) {
                              hour = 0;
                            }

// Combine date and time into a single DateTime object
                            DateTime rideDateTime = DateTime(
                                int.parse(dateString.split("-")[0]), // Year
                                int.parse(dateString.split("-")[1]), // Month
                                int.parse(dateString.split("-")[2]), // Day
                                hour,
                                minute
                            );

                            // print(rideDateTime);

// Determine cutoff DateTime
                            DateTime cutoff = DateTime.now();
                            if (rideDateTime.hour == 7 &&
                                rideDateTime.minute == 30) { // Morning ride
                              cutoff = DateTime(rideDateTime.year, rideDateTime.month, rideDateTime.day, 23, 30).subtract(Duration(days: 1));
                            } else if (rideDateTime.hour == 17 && rideDateTime.minute == 30) { // Evening ride
                              cutoff = DateTime(
                                  rideDateTime.year, rideDateTime.month,
                                  rideDateTime.day, 16, 30);
                            } else {
                              // Handle other cases or set a default cutoff
                            }

                            // Check if current time is after the cutoff
                            if (DateTime.now().isAfter(cutoff)) {
                              // Show message that the cutoff time has passed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Time Passed 🤦‍"),
                                    content: Text(
                                        "Unfortunately, The Time to reject this trip has passed 😢"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            else {
                              await FirebaseFirestore.instance.collection(
                                  'requests').doc(request['Id']).update(
                                  {
                                    'Requests': FieldValue.arrayRemove(
                                        [request])
                                  });
                              updateRideStatusInHistory(request, "Rejected 😪");
                            }

                            style: OutlinedButton.styleFrom(primary: Colors.blue);

                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
      ),

    );
  }
}

