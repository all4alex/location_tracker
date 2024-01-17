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
  final int onboardPassengerCount;
  final int maxPassengerCount;
  TripLocationUpdatesModel({
    this.tripId,
    this.driver,
    this.from,
    this.to,
    this.currentLat,
    this.currentLong,
    required this.dateTime,
    required this.onboardPassengerCount,
    required this.maxPassengerCount,
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
      'onboardPassengerCount': onboardPassengerCount,
      'maxPassengerCount': maxPassengerCount,
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
      onboardPassengerCount: map['onboardPassengerCount'] as int,
      maxPassengerCount: map['maxPassengerCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripLocationUpdatesModel.fromJson(String source) =>
      TripLocationUpdatesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  TripLocationUpdatesModel copyWith({
    String? tripId,
    String? driver,
    String? from,
    String? to,
    double? currentLat,
    double? currentLong,
    int? dateTime,
    int? onboardPassengerCount,
    int? maxPassengerCount,
  }) {
    return TripLocationUpdatesModel(
      tripId: tripId ?? this.tripId,
      driver: driver ?? this.driver,
      from: from ?? this.from,
      to: to ?? this.to,
      currentLat: currentLat ?? this.currentLat,
      currentLong: currentLong ?? this.currentLong,
      dateTime: dateTime ?? this.dateTime,
      onboardPassengerCount:
          onboardPassengerCount ?? this.onboardPassengerCount,
      maxPassengerCount: maxPassengerCount ?? this.maxPassengerCount,
    );
  }

  @override
  String toString() {
    return 'TripLocationUpdatesModel(tripId: $tripId, driver: $driver, from: $from, to: $to, currentLat: $currentLat, currentLong: $currentLong, dateTime: $dateTime, onboardPassengerCount: $onboardPassengerCount, maxPassengerCount: $maxPassengerCount)';
  }

  @override
  bool operator ==(covariant TripLocationUpdatesModel other) {
    if (identical(this, other)) return true;

    return other.tripId == tripId &&
        other.driver == driver &&
        other.from == from &&
        other.to == to &&
        other.currentLat == currentLat &&
        other.currentLong == currentLong &&
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
        currentLat.hashCode ^
        currentLong.hashCode ^
        dateTime.hashCode ^
        onboardPassengerCount.hashCode ^
        maxPassengerCount.hashCode;
  }
}
