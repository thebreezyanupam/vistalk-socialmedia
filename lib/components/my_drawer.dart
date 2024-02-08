import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});
  //log out user
  void logout(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                 DrawerHeader(
                  child: Container(
                    child:Image(image: AssetImage('assets/vistalk.png'), color: Theme.of(context).colorScheme.inversePrimary,),
                    width: 150,
                  ),

                ),

                const SizedBox(height: 20,),
                // Home
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('HOME'),
                    onTap: () {
                      // This is already the home screen so just pop the drawer
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 20,),

                // Profile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('PROFILE'),
                    onTap: () {
                      // This is already the home screen so just pop the drawer
                      Navigator.pop(context);

                      //navigate to profile page
                      Navigator.pushNamed(context, '/profile_page');
                    },
                  ),
                ),

              ],
            ),
            // Drawer header without underline


            // Logout
            Padding(
              padding: const EdgeInsets.only(left:25.0,bottom: 25.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LOGOUT'),
                onTap: () {
                  // This is already the home screen so just pop the drawer
                  Navigator.pop(context);
                  //logout
                  logout();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
