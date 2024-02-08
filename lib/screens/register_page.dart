import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_buttons.dart';
import '../components/my_textfield.dart';
import '../helper/helper_function.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmpasswordController = TextEditingController();

  // login method
  void registerUser() async{
    //show loading circle
    showDialog(context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    //make sure password match
    if (passwordController.text != confirmpasswordController.text){
      //pop loading circle
      Navigator.pop(context);

      //display error message to user
      displayMessageToUser("Password don't match!", context);
    }else{

      //try creating the user
      try{
        //create the user
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text,);

        //create a user document and add to firestore
        createUserDocument(userCredential);

        //pop loading circle
        if (context.mounted) Navigator.pop(context);
      }on FirebaseAuthException catch (e){
        //pop loading circle

        //show error message to the user
        displayMessageToUser(e.code, context);

      }
    }

  }
  //create a user document and collect them in firestore

  Future<void> createUserDocument(UserCredential? userCredential) async{
    if (userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': usernameController.text,

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const SizedBox(height: 150,),
                const SizedBox(width: 150,child:
                Image(image: AssetImage('assets/vistalk.png'),

                ),

                ),
                //username

                const SizedBox(height: 60,),

                // app name

                // email textfield
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,

                ),

                const SizedBox(height: 10,),

                // app name

                // email textfield
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,

                ),

                const SizedBox(height: 10,),

                // password textfield
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,

                ),
                const SizedBox(height: 10,),

                // password textfield
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmpasswordController,

                ),

                const SizedBox(height: 20,),

                // sign in button
                MyButtons(text: "Register", onTap: registerUser),

                const SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style:
                    TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(" Login!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,

                        ),),
                    ),
                  ],
                ),


                // don't have an account? Register here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
