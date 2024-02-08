import 'package:Vistalk/screens/home_page.dart';
import 'package:Vistalk/screens/my_splash_screen.dart';
import 'package:Vistalk/screens/profile_page.dart';
import 'package:Vistalk/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/login_or_register.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MySplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {

        '/login_register_page':(context)=> const LoginOrRegister(),
        '/home_page':(context)=>  MyHomepage(postId: '', likes: [],),
        '/profile_page':(context)=> MyProfile(),

      },

    );
  }
}

