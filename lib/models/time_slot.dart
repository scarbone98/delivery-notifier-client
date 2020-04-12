import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final bool available;
  final int cutoffTime;
  final int endTime;
  final String fulfillmentType;
  final int startTime;
  final int priority;
  final String day;

  TimeSlot(
      {this.available,
      this.cutoffTime,
      this.endTime,
      this.fulfillmentType,
      this.startTime,
      this.priority,
      this.day});

  static TimeSlot fromJson(Map<String, dynamic> json) {
    return TimeSlot(
        available: json['available'],
        cutoffTime: json['cutoffTime'],
        endTime: json['endTime'],
        fulfillmentType: json['fulfillmentType'],
        startTime: json['startTime'],
        priority: json['priority'],
        day: json['day']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = this.available;
    data['cutoffTime'] = this.cutoffTime;
    data['endTime'] = this.endTime;
    data['fulfillmentType'] = this.fulfillmentType;
    data['startTime'] = this.startTime;
    data['priority'] = this.priority;
    data['day'] = this.day;
    return data;
  }

  @override
  List<Object> get props => [
        available,
        cutoffTime,
        endTime,
        fulfillmentType,
        startTime,
        priority,
        day
      ];
}
