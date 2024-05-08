import 'package:flutter/material.dart';


import 'package:musicplayer2/pages/login.dart';

import 'package:musicplayer2/pages/test.dart';
import '../pages/settings_page.dart';

import 'package:musicplayer2/pages/listpage.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // logo
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),

          // home list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);
              },
            ),
          ),

          // settings list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);

                // navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),

       


           Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("S E A R C H"),
              leading: const Icon(Icons.search),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);

                // navigate to like page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
          ),

          
           Padding(
  padding: const EdgeInsets.only(left: 25.0),
  child: ListTile(
    title: const Text("F A V O U R I T E"),
    leading: const Icon(Icons.favorite), // แก้ไข Icon เป็น Icon ของ "heart" หรือ "favorite" ตามที่คุณต้องการ
    onTap: () {
      // pop the drawer
      Navigator.pop(context);

      // navigate to like page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FavPage(),
        ),
      );
    },
  ),
),

           
           Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("S I G N O U T"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                // pop the drawer
                Navigator.pop(context);

                // navigate to like page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
            ),
          ),


// Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: ListTile(
//               title: const Text("U P L O A D"),
//               leading: const Icon(Icons.search),
//               onTap: () async {
//                 Navigator.pop(context); // pop the drawer

//                 const url = 'http://192.168.50.217/flutter_login/upload.php';
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WebViewPage(url: url),
//                   ),
//                 );
//               },
//             ),
//           ),




          


          




        ],
      ),
    );
  }
}
