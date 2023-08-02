
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../parking/Home.dart';
import '../parking/ListeParkingSaved.dart';
import '../parking/saved.dart';
import '../users/editProfile.dart';
import '../users/profile.dart';

// class NavigationBottom extends StatefulWidget {
//   const NavigationBottom({Key? key}) : super(key: key);
//
//   @override
//   State<NavigationBottom> createState() => _NavigationBottomState();
// }
//
// class _NavigationBottomState extends State<NavigationBottom> {
//   int _currentIndex = 0;
//   final List<Widget> _interfaces = const [Home(), EditProfilePage(), Info()];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _interfaces[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         elevation: 0, // Set elevation to 0 to remove the shadow effect
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.save_as_sharp),
//             label: "Saved",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           )
//         ],
//         currentIndex: _currentIndex,
//         onTap: (value) {
//           setState(() {
//             _currentIndex = value;
//           });
//         },
//       ),
//     );
//   }
// }
//
class NavigationBottom extends StatefulWidget {
  @override
  _CurvedNavigationBarDemoState createState() => _CurvedNavigationBarDemoState();


}

class _CurvedNavigationBarDemoState extends State<NavigationBottom> {
  int _currentIndex = 0;
  String userEmail = '';

  final List<Widget> _screens = [
     Home(),
   ProfileInterface(),
    ListParkingSaved()
  ];
  @override
  void initState() {
    super.initState();
    getUserEmail();
  }
  Future<void> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString("userEmail") ?? '';
      print(prefs.getString("userEmail"));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(

        backgroundColor: Colors.white,
        color: Color(0xFF999CF3),
        buttonBackgroundColor: Color(0xFF4448AE),
        height: 50,

        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.bookmarks, size: 30, color: Colors.white),
          // Add more icons here
        ],
        onTap: (index)  {

          setState(() {

            _currentIndex = index;
          });
        },
      ),
    );
  }

}
