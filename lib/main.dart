import 'package:flutter/material.dart';

import 'package:musicplayer2/pages/login.dart';
import 'package:musicplayer2/pages/register.dart';
import 'package:musicplayer2/models/like.dart';
import 'package:provider/provider.dart';

import 'models/playlist.dart';
import 'pages/home_page.dart';
import 'theme/theme_provider.dart';



void main() {
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LikeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const login(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        'register': (context) => register(),
        'home':(context) => HomePage(),
        'login':(context) => login(),
      }
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:musicplayer2/pages/login.dart';
// import 'package:musicplayer2/pages/register.dart';
// import 'package:musicplayer2/models/like.dart';
// import 'package:provider/provider.dart';

// import 'models/playlist.dart';
// import 'pages/home_page.dart';
// import 'theme/theme_provider.dart';
// import 'package:firebase_core/firebase_core.dart';


// void main() async { // เพิ่ม async ที่นี่
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(

//   ); // เพิ่ม await ที่นี่
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => PlaylistProvider()),
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => LikeProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}); // แก้ key เป็น Key?

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//       theme: Provider.of<ThemeProvider>(context).themeData,
//       routes: {
//         'register': (context) => register(), // แก้ register เป็น Register()
//         'home': (context) => HomePage(),
//         'login': (context) => login(), // แก้ login เป็น Login()
//       },
//     );
//   }
// }

