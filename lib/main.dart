// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mexpense/firebase_options.dart';
import 'package:flutter_mexpense/mexpense/trip_entity.dart';
import 'package:flutter_mexpense/mexpense/trip_list.dart';
import 'package:flutter_mexpense/mexpense/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mexpense/new_trip.dart';
import 'mexpense/route_names.dart';

// void main() {
//   runApp(MExpense());
// }

Future main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const MExpense());
    }

//this is the main entry of the app

class MExpense extends StatelessWidget {
  const MExpense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.NewTrip: (context) => NewTrip(
              theTrip: TripEntity.empty(),
            ),
            RouteNames.TripList:(context) => TripList(),
      },
       initialRoute: RouteNames.TripList,
      // home: Welcome()
    );
  }
}
