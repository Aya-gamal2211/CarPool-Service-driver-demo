
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fireStore.dart';
import 'rides.dart';

class AddRide extends StatefulWidget {
  const AddRide({super.key});

  @override
  State<AddRide> createState() => _AddRide();
}


class _AddRide extends State <AddRide> {
  TextEditingController _toController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _feesController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  GlobalKey <FormState> _formKey = GlobalKey();
  String Date = '';
  List<String> toOptions = ['gate3', 'gate4'];
  List<String> timeOptions = ['5:30 PM', '7:30 AM'];
  String selectedTime = '5:30 PM'; // Default selected time

  fireStore _store= fireStore();
  void _showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 2),
// Adjust the duration as needed
      action: SnackBarAction(label: 'Undo',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _handleRides() {
    // Implement your signup logic here
    // String To = _toController.text;
    // String From = _fromController.text;
    // String Time = _timeController.text;
    // String Date = _dateController.text;
    // String Fees = _feesController.text;

    if (_formKey.currentState != null) {
      // Process the form data

      // Access the data from the controllers
      String To = _toController.text;
      String From = _fromController.text;

      String Fees = _feesController.text;

      // Now you have the validated data, you can proceed with further processing

      // Validate input
      if (To.isEmpty || From.isEmpty || selectedTime.isEmpty || Date.isEmpty || Fees.isEmpty) {
        // Show an error message or toast
        _showErrorSnackBar("Please fill in the empty fields");


        return false; // Conditions are not satisfied
      }
    }

    return true; // Conditions are satisfied
  }


String generateID(){
    var id=FirebaseFirestore.instance.collection('dummy').doc().id;
    return id;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ride'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children:[
              SizedBox(height: 32.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(

                    controller: _toController,
                    decoration: InputDecoration(labelText: 'Destination',
                    prefixIcon: Icon(Icons.location_searching)),
                  ),
                  SizedBox(height: 16.0),

                  TextField(

                    controller: _fromController,
                    decoration: InputDecoration(labelText: 'Pick up Location',
                    prefixIcon: Icon(Icons.location_on)),
                  ),
                  SizedBox(height: 16.0),
                  TextField(

                    controller: _feesController,
                    decoration: InputDecoration(labelText: 'Fees to be paid',
                    prefixIcon: Icon(Icons.money)),

                  ),
                  SizedBox(height: 16.0),

                  DateTimePicker(
                   type: DateTimePickerType.date,
                   dateMask:"d MMM, yyyy",
                    initialValue: DateTime.now().toString(),

                    dateLabelText: "Date",
                      firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                        Duration(days: 365)
                    ),
                    icon: Icon(Icons.date_range),
                    validator:(value){
                     return null;
                    },
                    onChanged: (selectedDate) {
                      // Handle the selected date if needed
                      setState(() {

                        Date=selectedDate!;
                      });

                      print(selectedDate);
                    },

                  ),
                  // TextField(
                  //   controller: _dateController,
                  //   decoration: InputDecoration(labelText: 'Date: 2023-12-25'),
                  //
                  // ),
                  SizedBox(height: 16.0),
                  DropdownButton<String>(

                    icon: Icon(Icons.timelapse),
                    value: selectedTime,
                    onChanged: (value) {
                      setState(() {

                        if (_toController.text.toLowerCase().replaceAll(" ","")==toOptions[0] || _toController.text.toLowerCase().replaceAll(" ","")==toOptions[1]){
                          selectedTime=timeOptions[1];
                        }
                        else{
                          selectedTime=timeOptions[0];
                        }
                        selectedTime = value!;
                      });
                    },
                    items: timeOptions.map((time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    //elevation: InputDecoration(labelText: 'Time: 5:30'),
                  ),


                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: (){

                      _handleRides();

                       if (_toController.text.toLowerCase().replaceAll(" ", "") == _fromController.text.toLowerCase().replaceAll(" ", "")) {
                        _showErrorSnackBar("Please change either the source or destination as they can't be the same");
                      }
                      else if (_toController.text.toLowerCase().replaceAll(" ", "") == toOptions[0] ||
                      _fromController.text.toLowerCase().replaceAll(" ", "") == toOptions[1] ||
                        _toController.text.toLowerCase().replaceAll(" ", "") == toOptions[1] ||
                        _fromController.text.toLowerCase().replaceAll(" ", "") == toOptions[1]) {
                         // print("ana hna");
                         _showErrorSnackBar(
                             "Either source or destination must be either gate 3 or gate 4");
                       }
                      else{
                        String rideId=generateID();
                         _store.addRide(
                             _toController.text, _fromController.text,
                             selectedTime, Date, _feesController.text,rideId);
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text("Ride added successfully!"),
                             duration: Duration(seconds: 2),
                           ),
                         );
                         Navigator.pushReplacementNamed(context, '/rides');
                       }
                    },
                    child: Text('Add Ride'),
                  ),
                ],
              ),
            ],
          ),
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
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
      ),

    );

  }
}
