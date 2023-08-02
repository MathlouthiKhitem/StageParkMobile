import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../parking/CountdownProgressIndicator.dart';
import '../parking/info.dart';
import 'nav_bottom.dart';
class NavigationTab extends StatefulWidget {
  @override
  _NavigationTabState createState() => _NavigationTabState();
}

class _NavigationTabState extends State<NavigationTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String duree = "";
  String sessionId="";
  FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  int durationInSeconds = 0; // Declare the variable here

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _retrieveData();
    super.initState();
  }
  void _navigateToTimeTab() {
    _tabController.animateTo(2); // 2 is the index of the "Time" tab
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      duree = prefs.getString("duree") ?? "";
      sessionId= prefs.getString("sessionId") ?? "";
      List<String> timeParts = duree.split(':');
      if (timeParts.length == 2) {
        int hours = int.tryParse(timeParts[0]) ?? 0;
        int minutes = int.tryParse(timeParts[1]) ?? 0;
        durationInSeconds = hours * 3600 + minutes * 60;
        print('Parsed duration: $durationInSeconds seconds');
        print('Parsed sessionId: $sessionId ');
      } else {
        print('Invalid value for duree: $duree');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(9.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  color: Colors.deepPurpleAccent,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: "Infomation",
                    icon: Icon(Icons.info_outlined),
                  ),
                  Tab(
                    text: "Home",
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    text: "Time",
                    icon: Icon(Icons.timelapse_outlined),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tabController.index,
                children: [
                  const Info(),
                  NavigationBottom(),
                  CountdownProgressIndicator(
                    durationInSeconds: durationInSeconds,
                    onTimerComplete: () {
                      // Handle timer completion
                    },
                    flutterLocalNotificationsPlugin: notificationsPlugin,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
