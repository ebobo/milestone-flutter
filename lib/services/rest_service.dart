import 'dart:async';
import 'package:http/http.dart' as http;

class RestService {
  String baseUrl = '';
  String authToken = '';

  Future<String> signinAPIgateway(String userName, String password) async {
    if (baseUrl == '' || authToken == '') {
      return 'Error';
    }
    final response = await http.post(Uri.parse(baseUrl + 'idp/connect/token'),
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
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
