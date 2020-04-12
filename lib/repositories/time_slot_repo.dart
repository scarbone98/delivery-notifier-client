import 'dart:async';
import 'dart:convert';
import 'package:deliverynotifier/models/models.dart';
import 'package:http/http.dart' as http;

class Repository {

  Future<Map<String, dynamic>> fetchItems(String zipCode) async {
    http.Response response = await http.get('http://10.0.2.2:5000/getAddress?zipCode=$zipCode');
    return jsonDecode(response.body);
  }

//  Stream<String> deleteItem(String id) async* {
//    await Future.delayed(Duration(seconds: _next(1, 5)));
//    yield id;
//  }
}