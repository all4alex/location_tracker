// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';

class TripModel {
  final String? tripId;
  final String? driver;
  final String? from;
  final String? to;
  final int dateTime;
  final int onboardPassengerCount;
  final int maxPassengerCount;
  TripModel({
    this.tripId,
    this.driver,
    this.from,
    this.to,
    required this.dateTime,
    required this.onboardPassengerCount,
    required this.maxPassengerCount,
  });

  TripModel copyWith({
    String? tripId,
    String? driver,
    String? from,
    String? to,
    int? dateTime,
    int? onboardPassengerCount,
    int? maxPassengerCount,
  }) {
    return TripModel(
      tripId: tripId ?? this.tripId,
      driver: driver ?? this.driver,
      from: from ?? this.from,
      to: to ?? this.to,
      dateTime: dateTime ?? this.dateTime,
      onboardPassengerCount:
          onboardPassengerCount ?? this.onboardPassengerCount,
      maxPassengerCount: maxPassengerCount ?? this.maxPassengerCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tripId': tripId,
      'driver': driver,
      'from': from,
      'to': to,
      'dateTime': dateTime,
      'onboardPassengerCount': onboardPassengerCount,
      'maxPassengerCount': maxPassengerCount,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      tripId: map['tripId'] != null ? map['tripId'] as String : null,
      driver: map['driver'] != null ? map['driver'] as String : null,
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      dateTime: map['dateTime'] as int,
      onboardPassengerCount: map['onboardPassengerCount'] as int,
      maxPassengerCount: map['maxPassengerCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripModel.fromJson(String source) =>
      TripModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TripModel(tripId: $tripId, driver: $driver, from: $from, to: $to, dateTime: $dateTime, onboardPassengerCount: $onboardPassengerCount, maxPassengerCount: $maxPassengerCount)';
  }

  @override
  bool operator ==(covariant TripModel other) {
    if (identical(this, other)) return true;

    return other.tripId == tripId &&
        other.driver == driver &&
        other.from == from &&
        other.to == to &&
        other.dateTime == dateTime &&
        other.onboardPassengerCount == onboardPassengerCount &&
        other.maxPassengerCount == maxPassengerCount;
  }

  @override
  int get hashCode {
    return tripId.hashCode ^
        driver.hashCode ^
        from.hashCode ^
        to.hashCode ^
        dateTime.hashCode ^
        onboardPassengerCount.hashCode ^
        maxPassengerCount.hashCode;
  }
}
