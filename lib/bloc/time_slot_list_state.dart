part of 'time_slot_list_bloc.dart';

abstract class TimeSlotListState extends Equatable {
  const TimeSlotListState();

  @override
  List<Object> get props => [];
}

class InitialLoad extends TimeSlotListState {}

class Loading extends TimeSlotListState {}

class Loaded extends TimeSlotListState {
  final List<TimeSlot> timeSlots;

  const Loaded({this.timeSlots});

  @override
  List<Object> get props => [timeSlots];

  @override
  String toString() => 'Loaded { items: ${timeSlots.length} }';
}

class Failure extends TimeSlotListState {
  final String message;
  Failure({this.message});
}