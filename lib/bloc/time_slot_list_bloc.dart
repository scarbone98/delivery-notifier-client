import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:deliverynotifier/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:deliverynotifier/models/models.dart';

part 'time_slot_list_event.dart';
part 'time_slot_list_state.dart';

class TimeSlotListBloc extends Bloc<TimeSlotListEvent, TimeSlotListState> {
  final Repository repository;

  TimeSlotListBloc({@required this.repository});

  @override
  TimeSlotListState get initialState => InitialLoad();

  @override
  Stream<TimeSlotListState> mapEventToState(
      TimeSlotListEvent event,
      ) async* {
    if (event is Fetch) {
      yield Loading();
      final itemsResponse = await repository.fetchItems(event.zipCode);
      if (itemsResponse['time_slots'] != null) {
        List<TimeSlot> timeSlots = List<TimeSlot>.generate(itemsResponse['time_slots'].length, (index) => TimeSlot.fromJson(itemsResponse['time_slots'][index]));
        yield Loaded(timeSlots: timeSlots);
      } else {
        yield Failure(message: itemsResponse['error_message']);
      }
    }
  }
}