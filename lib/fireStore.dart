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
  // var userref = FirebaseFirestore.instance.collection('rides');
  // Future<List> fetchdata()async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     var x = await userref.get();
  //     List mydoc = x.docs;
  //     return mydoc;
  //   }
  //   return [];
  // }
  Stream<List<DocumentSnapshot>> fetchdata() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return FirebaseFirestore.instance
          .collection('rides')
          .snapshots()
          .map((snapshot) => snapshot.docs);

    } else {
      return Stream.value([]); // Return an empty stream if the user is not logged in
    }
  }

  Future<void> editData(String firstName, String lastName, String mobile) async {
    final userID=FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('driver').doc(userID).update(
          {

            'firstName': firstName,
            'lastName': lastName,
            'phone':mobile,
          });
    } catch (e) {
      print('Error updating task data... $e');
      // Handle data saving errors here.
    }
  }



    }