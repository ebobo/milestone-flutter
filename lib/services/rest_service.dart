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

//webRTC
  Future<String> sendIceCandidate(String session, String candidate) async {
    if (baseUrl == '') {
      return 'Error';
    }
    final response = await http.post(
        Uri.parse('$baseUrl/api/WebRTC/v1/IceCandidates'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken'
        },
        body: jsonEncode(<String, dynamic>{
          'sessionId': 'sessionId',
          'candidates': [candidate]
        }));
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getOfferByCameraID(String cameraID) async {
    if (baseUrl == '') {
      return 'Error';
    }
    final response = await http.post(
        Uri.parse('$baseUrl/api/WebRTC/v1/WebRTCSession'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken'
        },
        body: jsonEncode(<String, String>{
          'cameraId': cameraID,
          'resolution': 'notInUse',
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['offerSDP'] != null) {
        // not only offerSDP
        return data;
      } else {
        return 'Error';
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> sendAnswer(dynamic session) async {
    if (baseUrl == '') {
      return 'Error';
    }
    final response = await http.put(
        Uri.parse('$baseUrl/api/WebRTC/v1/WebRTCSession'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken'
        },
        body: jsonEncode(session));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getRemoteIceCandidate(String sessionId) async {
    if (baseUrl == '' || _authToken == '') {
      return [];
    }
    final response = await http.get(
        Uri.parse('$baseUrl/api/WebRTC/v1/IceCandidates/$sessionId'),
        headers: <String, String>{'Authorization': 'Bearer $_authToken'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] is List) {
        return List<dynamic>.from(data['candidates']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
