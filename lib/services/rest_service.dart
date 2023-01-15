import 'dart:convert';
import 'package:http/http.dart' as http;

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
      print(_authToken);
      return 'Success';
    } else {
      throw Exception('Failed to load data');
    }
  }
}
