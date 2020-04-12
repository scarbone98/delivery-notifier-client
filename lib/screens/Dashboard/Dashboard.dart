import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverynotifier/bloc/time_slot_list_bloc.dart';
import 'package:deliverynotifier/models/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription _iosSubscription;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        // TODO optional
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        // TODO optional
//      },
//    );
  }

  Widget _renderTimeSlots(List<TimeSlot> timeSlotsData) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          var timeSlotInfo = timeSlotsData[index];
          var startTime = DateFormat().add_jm().format(
                DateTime.fromMillisecondsSinceEpoch(
                  timeSlotInfo.startTime.toInt(),
                ),
              );
          var endTime = DateFormat().add_jm().format(
                DateTime.fromMillisecondsSinceEpoch(
                  timeSlotInfo.endTime.toInt(),
                ),
              );
          var fullDateFormatted =
              DateFormat().add_MMMMd().format(DateTime.parse(timeSlotInfo.day));
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4)),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(fullDateFormatted),
                    Text('$startTime - $endTime')
                  ],
                ),
              ],
            ),
          );
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: timeSlotsData.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Zip',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLength: 5,
              onSubmitted: (newValue) =>
                  BlocProvider.of<TimeSlotListBloc>(context)
                      .add(Fetch(zipCode: newValue)),
            ),
            Expanded(
              child: BlocBuilder<TimeSlotListBloc, TimeSlotListState>(
                builder: (context, state) {
                  if (state is Failure) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${state.message}'),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    );
                  } else if (state is Loaded) {
                    if (state.timeSlots.length == 0) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              'It seems there are no available timeslots :(',
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            FlatButton(
                              onPressed: () => print('TRACKING'),
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Track?',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Available Walmart timeslots (${state.timeSlots.length})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        _renderTimeSlots(state.timeSlots)
                      ],
                    );
                  } else if (state is InitialLoad) {
                    return Column(
                      children: <Widget>[
                        Text(
                            'Enter a zip code to see currently available timeslots.')
                      ],
                    );
                  } else {
                    return SpinKitFoldingCube(
                      color: Colors.blue,
                      size: 50.0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
