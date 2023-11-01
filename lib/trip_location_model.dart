// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TripLocationModel {
  final String? tripId;
  final String? driver;
  final String? from;
  final String? to;
  final double? startLat;
  final double? startLon;
  final String? status;
  final int dateTime;
  final List<String> locationUpdates;
  TripLocationModel({
    this.tripId,
    this.driver,
    this.from,
    this.to,
    this.startLat,
    this.startLon,
    this.status,
    required this.dateTime,
    required this.locationUpdates,
  });

  TripLocationModel copyWith({
    String? tripId,
    String? driver,
    String? from,
    String? to,
    double? startLat,
    double? startLon,
    String? status,
    int? dateTime,
    List<String>? locationUpdates,
  }) {
    return TripLocationModel(
      tripId: tripId ?? this.tripId,
      driver: driver ?? this.driver,
      from: from ?? this.from,
      to: to ?? this.to,
      startLat: startLat ?? this.startLat,
      startLon: startLon ?? this.startLon,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      locationUpdates: locationUpdates ?? this.locationUpdates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tripId': tripId,
      'driver': driver,
      'from': from,
      'to': to,
      'startLat': startLat,
      'startLon': startLon,
      'status': status,
      'dateTime': dateTime,
      'locationUpdates': locationUpdates,
    };
  }

  factory TripLocationModel.fromMap(Map<String, dynamic> map) {
    return TripLocationModel(
        tripId: map['tripId'] != null ? map['tripId'] as String : null,
        driver: map['driver'] != null ? map['driver'] as String : null,
        from: map['from'] != null ? map['from'] as String : null,
        to: map['to'] != null ? map['to'] as String : null,
        startLat: map['startLat'] != null ? map['startLat'] as double : null,
        startLon: map['startLon'] != null ? map['startLon'] as double : null,
        status: map['status'] != null ? map['status'] as String : null,
        dateTime: map['dateTime'] as int,
        locationUpdates: List<String>.from(
          (map['locationUpdates'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory TripLocationModel.fromJson(String source) =>
      TripLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TripLocationModel(tripId: $tripId, driver: $driver, from: $from, to: $to, startLat: $startLat, startLon: $startLon, status: $status, dateTime: $dateTime, locationUpdates: $locationUpdates)';
  }

  @override
  bool operator ==(covariant TripLocationModel other) {
    if (identical(this, other)) return true;

    return other.tripId == tripId &&
        other.driver == driver &&
        other.from == from &&
        other.to == to &&
        other.startLat == startLat &&
        other.startLon == startLon &&
        other.status == status &&
        other.dateTime == dateTime &&
        listEquals(other.locationUpdates, locationUpdates);
  }

  @override
  int get hashCode {
    return tripId.hashCode ^
        driver.hashCode ^
        from.hashCode ^
        to.hashCode ^
        startLat.hashCode ^
        startLon.hashCode ^
        status.hashCode ^
        dateTime.hashCode ^
        locationUpdates.hashCode;
  }
}
