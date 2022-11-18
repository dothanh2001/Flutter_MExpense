import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mexpense/mexpense/constant.dart';
import 'package:flutter_mexpense/mexpense/new_trip.dart';
import 'package:flutter_mexpense/mexpense/route_names.dart';
import 'package:flutter_mexpense/mexpense/trip_entity.dart';

class TripList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.NewTrip);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<TripEntity>>(
        stream: readTrip(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! $snapshot");
          } else if (snapshot.hasData) {
            final trips = snapshot.data!;
            return buildListView(trips);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView buildListView(List<TripEntity> trips) {
    return ListView.builder(
        itemCount: trips.length,
        itemBuilder: ((context, index) {
          final t = trips[index];
          return ListTile(
            onTap: () {
              print(t.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTrip(theTrip: t),
                  ));
            },
            title: Text(
              t.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          );
        }));
  }

  Stream<List<TripEntity>> readTrip() {
    return FirebaseFirestore.instance
        .collection(Constants.fsTrip)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((doc) => TripEntity.fromJson(doc.id, doc.data()))
            .toList());
  }
}
