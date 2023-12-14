
import 'package:driver_demo/fireStore.dart';
import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
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
  List<Map> offeredRides = [];

  List mylist = [];
  fireStore mydata=fireStore();
  @override
  Widget build(BuildContext context) {

    Map rideDetails=ModalRoute.of(context)!.settings.arguments as Map;


        // Add the ride details to the local list
        offeredRides.add({
          'to': rideDetails['To'],
          'from': rideDetails['From'],
          'date': rideDetails['Date'],
          'time': rideDetails['Time'],
          'fees': rideDetails['Fees'],
        });

        // Update the UI
        setState(() {
          // You may want to update the UI in response to the new ride being offered
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
                 FutureBuilder(
                         future: mydata.fetchdata(),
                         builder: (context,snapshot){
                           if(snapshot.hasData)  {
                             mylist = snapshot.data!;
                             return ListView.builder(
                                 itemCount: mylist.length,
                                 itemBuilder: (context,index) {
                                   return Card(
                                     child: ListTile(
                                       leading: Icon(Icons.car_crash_outlined,color: Colors.blue,),

                                         title: Column(

                                           children: [
                                             Text("Destination : ${mylist[index].data()['to']}",style: TextStyle(
                                               color: Colors.blueGrey,
                                             ),),
                                             Text("Source : ${mylist[index].data()['from']}",style: TextStyle(
                                               color: Colors.blueGrey,
                                             ),),
                                           ],
                                         ),
                                         subtitle:Column(

                                           children: [
                                             Text("Date : ${mylist[index].data()['date']}",style: TextStyle(
                                               color: Colors.blueGrey,),

                                             ),
                                             Text("Time : ${mylist[index].data()['time']}",style: TextStyle(
                                               color: Colors.blueGrey,),
                                             ),
                                             Text("Fees :  \$ ${mylist[index].data()['fees']}",style: TextStyle(
                                               color: Colors.blueGrey,),
                                             ),
                                           ],
                                         )),
                                   );
                                 });
                           }
                           else if(snapshot.hasError){
                             return const Text("Hard Luck");
                           }
                           else{
                             return const CircularProgressIndicator();
                           }
                         }),

      ),


          ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addRide');

        },
        child: Text('Add Ride'),
        ),
        ],
      ),

    );
  }




}
