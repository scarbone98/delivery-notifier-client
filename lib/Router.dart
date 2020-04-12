import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/Login/Login.dart';
import 'screens/Dashboard/Dashboard.dart';
import 'package:bloc/bloc.dart';
import 'repositories/repositories.dart';
import 'package:deliverynotifier/bloc/time_slot_list_bloc.dart';

class MatchPageArguments {
  final String roomId;

  MatchPageArguments({this.roomId});
}

class WidgetWrapper extends StatelessWidget {
  final Widget child;
  final String pageTitle;
  final bool bottomBar;

  const WidgetWrapper(
      {Key key, @required this.child, this.bottomBar = false, this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: child,
        ),
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: LoginScreen(),
            resizeToAvoidBottomInset: false,
          ),
        );
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => DefaultTabController(
            initialIndex: 0,
            length: 1,
            child: BlocProvider(
              create: (context) => TimeSlotListBloc(repository: Repository()),
              child: Scaffold(
                  backgroundColor: Colors.white,
                  bottomNavigationBar: SafeArea(
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(icon: Icon(Icons.person, color: Colors.black54)),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      DashboardScreen()
                    ],
                  )),
            ),
          ),
        );
        break;
      default:
        return MaterialPageRoute(
          builder: (_) => WidgetWrapper(child: LoginScreen()),
        );
    }
  }
}
