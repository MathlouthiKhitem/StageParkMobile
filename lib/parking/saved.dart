import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'ListeParkingSaved.dart';
import 'home.dart';

class ProductInfo extends StatelessWidget {
  final ParkingInfo game;

  const ProductInfo(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // const Padding(
          //   padding: EdgeInsets.fromLTRB(90, 0, 30, 60),
          //   child: Row(
          //     children: [
          //       Icon(Icons.bookmark, size: 24),
          //       SizedBox(width: 10),
          //       Text(
          //         'My Bookmark',
          //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.parkingName),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("${game.zoneName} ", textScaleFactor: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


