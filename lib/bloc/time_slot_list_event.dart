part of 'time_slot_list_bloc.dart';

abstract class TimeSlotListEvent extends Equatable {
  const TimeSlotListEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends TimeSlotListEvent {
  final String zipCode;
  const Fetch({this.zipCode});

  @override
  List<Object> get props => [zipCode];

}

class Delete extends TimeSlotListEvent {
  final String id;

  const Delete({this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Delete { id: $id }';
}

class Deleted extends TimeSlotListEvent {
  final String id;

  const Deleted({@required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Deleted { id: $id }';
}