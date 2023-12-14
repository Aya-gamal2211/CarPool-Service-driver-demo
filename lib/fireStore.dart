import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class fireStore{
  Future<void> addRide(String To, String From, String Time, String Date, String Fees ) async
  {
    try {
      CollectionReference Rides = FirebaseFirestore.instance.collection('rides');

      DocumentReference result = await Rides.add(
          {
        'to': To,
        'from': From,
        'date': Date,
        'time': Time,
        'fees':Fees,
      });
      }

    catch (e) {
      print('Error saving task data... $e');
      // Handle data saving errors here.
    }
    }

      // Get the document ID of the added ride
      // String rideId = result.id;
  var userref = FirebaseFirestore.instance.collection('rides');
  Future<List> fetchdata()async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var x = await userref.get();
      List mydoc = x.docs;
      return mydoc;
    }
    return [];
  }
    }