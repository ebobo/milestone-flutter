import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:milestone_flutter/models/cameras.dart';

class RestService {
  String baseUrl = '';
  String _authToken = '';

  Future<String> signinAPIgateway(String userName, String password) async {
    if (baseUrl == '') {
      return 'Error';
    }
    final response = await http.post(Uri.parse('$baseUrl/idp/connect/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: <String, String>{
          'grant_type': 'password',
          'username': userName,
          'password': password,
          'client_id': 'GrantValidatorClient',
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _authToken = data['access_token'];
      return 'Success';
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Camera>> getCamras() async {
    if (baseUrl == '' || _authToken == '') {
      return [];
    }
    final response = await http.get(Uri.parse('$baseUrl/api/rest/v1/cameras'),
        headers: <String, String>{'Authorization': 'Bearer $_authToken'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['array'] is List) {
        return List<dynamic>.from(data['array'])
            .map((e) => Camera.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
