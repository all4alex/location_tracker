import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class TripLocationUpdatesModel {
  final String? tripId;
  final String? driver;
  final String? from;
  final String? to;
  final double? currentLat;
  final double? currentLong;
  final int dateTime;
  TripLocationUpdatesModel({
    this.tripId,
    this.driver,
    this.from,
    this.to,
    this.currentLat,
    this.currentLong,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tripId': tripId,
      'driver': driver,
      'from': from,
      'to': to,
      'currentLat': currentLat,
      'currentLong': currentLong,
      'dateTime': dateTime,
    };
  }

  factory TripLocationUpdatesModel.fromMap(Map<String, dynamic> map) {
    return TripLocationUpdatesModel(
      tripId: map['tripId'] != null ? map['tripId'] as String : null,
      driver: map['driver'] != null ? map['driver'] as String : null,
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      currentLat:
          map['currentLat'] != null ? map['currentLat'] as double : null,
      currentLong:
          map['currentLong'] != null ? map['currentLong'] as double : null,
      dateTime: map['dateTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripLocationUpdatesModel.fromJson(String source) =>
      TripLocationUpdatesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
