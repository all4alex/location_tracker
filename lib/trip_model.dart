import 'dart:convert';

import 'package:flutter/widgets.dart';

class TripModel {
  final String? tripId;
  final String? driver;
  final String? from;
  final String? to;
  final int dateTime;
  TripModel({
    this.tripId,
    this.driver,
    this.from,
    this.to,
    required this.dateTime,
  });

  TripModel copyWith({
    ValueGetter<String?>? tripId,
    ValueGetter<String?>? driver,
    ValueGetter<String?>? from,
    ValueGetter<String?>? to,
    int? dateTime,
  }) {
    return TripModel(
      tripId: tripId != null ? tripId() : this.tripId,
      driver: driver != null ? driver() : this.driver,
      from: from != null ? from() : this.from,
      to: to != null ? to() : this.to,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'driver': driver,
      'from': from,
      'to': to,
      'dateTime': dateTime,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      tripId: map['tripId'],
      driver: map['driver'],
      from: map['from'],
      to: map['to'],
      dateTime: map['dateTime']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripModel.fromJson(String source) =>
      TripModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripModel(tripId: $tripId, driver: $driver, from: $from, to: $to, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripModel &&
        other.tripId == tripId &&
        other.driver == driver &&
        other.from == from &&
        other.to == to &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return tripId.hashCode ^
        driver.hashCode ^
        from.hashCode ^
        to.hashCode ^
        dateTime.hashCode;
  }
}
