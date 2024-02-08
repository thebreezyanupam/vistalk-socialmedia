import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_back_buttons.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});
  //log out user
  void logout(){
    FirebaseAuth.instance.signOut();
  }

  //current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // future to fetch user defaults
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot){
          //loading
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //error
          else if(snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }

          //data
          else if(snapshot.hasData){
            //extract data
            Map<String, dynamic>? user = snapshot.data!.data();
            if (user == null){
              return const Text('User data is null!');
            }

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(),
                        GestureDetector(
                          onTap: () {
                            logout();
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.logout_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Profile Picture
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 40),
                    // User Info
                    Text(
                      user?['username'] ?? 'N/A',
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?['email'] ?? 'N/A',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 40),
                    //Current User Posts displayed in profile


                  ],
                ),
              ),
            );

          }else{
            return const Text('No data!');
          }
        },
      ),
    );
  }
}
