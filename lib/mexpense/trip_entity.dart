import 'package:flutter_mexpense/mexpense/constant.dart';

class TripEntity {
  String id = Constants.newTripId;
  String name = Constants.emptyString;
  String destination = Constants.emptyString;
  String date = Constants.emptyString;
  String description = Constants.emptyString;
  String risk = Constants.emptyString;
  int participant = 0;

  TripEntity(this.id, this.name, this.destination, this.date, this.description,
      this.risk, this.participant);
  TripEntity.newTrip(String name, String destination, String date,
      String description, String risk, int participant)
      : this(Constants.emptyString, name, destination, description, date, risk,
            participant);
            TripEntity.empty();

  static TripEntity fromJson(String docId, Map<String, dynamic> json) {
    return TripEntity(
        docId,
        json['name'],
        json['destination'],
        json['date'],
        json['risk'],
        json['description'],
        int.parse(json['participant'].toString())
        );
  }

  Map<String, dynamic> getHashMap() {
    return <String, dynamic>{
      "name": name,
      "destination": destination,
      "date": date,
      "risk": risk,
      };
  }
}
