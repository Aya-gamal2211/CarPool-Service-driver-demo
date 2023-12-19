import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageState();
}

class _ManageState extends State<ManageAccount> {



  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  Future <void> FetchUser() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance.collection('driver').doc(
        userID).get();
    Map<String,dynamic>? data=snapshot as Map<String, dynamic>?;
    _firstNameController.text=data!['firstName'];
    _lastNameController.text=data!['lastName'];
    _mobileController.text=data!['phone'];


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
          title:
          Text("Edit Profile"),
        ),


        body:ListView(

            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    _buildTextField(_firstNameController, "First Name"),
                    SizedBox(height: 20),
                    _buildTextField(_lastNameController, "Last Name"),
                    SizedBox(height: 20),
                    _buildTextField(_mobileController, "Mobile"),
                    SizedBox(height: 40),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        onPressed: ()  async{

                          fireStore fire=fireStore();
                          await fire.editData(_firstNameController.text,_lastNameController.text,_mobileController.text);



                          Navigator.pushReplacementNamed(context, '/Profile');
                        },
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontWeight:
                          FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])
    );
  }
  Widget _buildTextField(TextEditingController controller, String label,
      ) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
