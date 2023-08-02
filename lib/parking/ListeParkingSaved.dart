import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripedemo/parking/saved.dart';


class ListParkingSaved extends StatefulWidget {
  const ListParkingSaved({Key? key}) : super(key: key);

  @override
  State<ListParkingSaved> createState() => _ListParkingSavedState();
}

class _ListParkingSavedState extends State<ListParkingSaved> {

  final List<ParkingInfo> _games = [];

  final String _baseUrl = "10.0.2.2:8080";
  late Future<bool> fetchedGames;

  Future<bool> fetchGames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId= prefs.getString("userId");
    http.Response response = await http.get(
        Uri.http(_baseUrl, "/Backend/users/$clientId/parkings"));

    List<dynamic> gamesFromServer = json.decode(response.body);
    gamesFromServer.forEach((game) {
      _games.add(ParkingInfo(game["zoneTitle"], game["numeroParking"]));
    });

    return true;
  }

  @override
  void initState() {
    fetchedGames = fetchGames();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedGames,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: _games.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductInfo(_games[index]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}
class ParkingInfo {
  final String parkingName;
  final String zoneName;

  ParkingInfo(this.parkingName, this.zoneName);
}
