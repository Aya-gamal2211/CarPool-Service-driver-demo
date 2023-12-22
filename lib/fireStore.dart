import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class fireStore{
  Future<void> addRide(String To, String From, String Time, String Date, String Fees,String rideID ) async
  {
    final uid=FirebaseAuth.instance.currentUser?.uid;
    try {
      CollectionReference Rides = FirebaseFirestore.instance.collection('rides');

      DocumentReference result = await Rides.add(
          {
        'to': To,
        'from': From,
        'date': Date,
        'time': Time,
        'fees':Fees,
            'id':uid,
            'rideID':rideID
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
  Future<void> updateRequestRides(Map<String, dynamic> updateData) async {
    try {
      final Uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference requestDoc = FirebaseFirestore.instance.collection('requests').doc(Uid);
      var docSnapshot = await requestDoc.get();
      if (docSnapshot.exists) {
        // Document exists, proceed with the update
        await requestDoc.update({
          'Requests': FieldValue.arrayUnion([updateData])
        });
      } else {
        // Document does not exist, handle accordingly
        print('Document does not exist');
      }
    }
    catch (e) {
      //   print('Error updating Firestore: $e');
      //   // Handle error as needed
      // }
    }
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
        .doc(currentUser.uid)
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
          'date': requestItem['date'],
          'time': requestItem['time'],
          'fees': requestItem['fees'],
          // 'status': requestItem['status'],
          // 'id': requestItem['id'],
        };
      }).toList();
    });
  }
}



