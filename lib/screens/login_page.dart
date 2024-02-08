import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_buttons.dart';
import '../components/my_textfield.dart';
import '../helper/helper_function.dart';

class LoginPage extends StatefulWidget {


  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // login method
 void loginUser() async{
   //show loading circle
   showDialog(context: context,
     builder: (context) => const Center(
       child: CircularProgressIndicator(),
     ),
   );
   //try sign in
   try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text,);

     //pop the loading circle
     if(context.mounted) Navigator.pop(context);
   }
   //display the error
   on FirebaseAuthException catch (e){
     //pop loading circle
     Navigator.pop(context);
     displayMessageToUser(e.code, context);
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
                const SizedBox(height: 200,),
                const SizedBox(width: 150,child:
                  Image(image: AssetImage('assets/vistalk.png'),

                  ),

                ),

                const SizedBox(height: 60,),

                // app name

                // email textfield
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,

                ),

                const SizedBox(height: 20,),

                // password textfield
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,

                ),
                const SizedBox(height: 10,),

                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password?', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, decoration: TextDecoration.underline)),
                  ],
                ),
                const SizedBox(height: 20,),

                // sign in button
                MyButtons(text: "Login", onTap: loginUser),

                const SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style:
                      TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(" Register Here!",
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
