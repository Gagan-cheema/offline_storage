import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://182.72.111.237:89/public/api";
  String? _token;
  DateTime? _tokenExpiry;

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': 'admin@mrcc.com', 'password': 'admin@123'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data != null && data['access_token'] is String) {
        print("token ------ ${data['access_token']}");
        _token = data['access_token'] as String;
        _tokenExpiry = DateTime.now().add(Duration(seconds: data['expires_in'] as int));
      } else {
        throw Exception('Token not found or invalid format');
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> _checkAndRefreshToken() async {
    if (DateTime.now().isAfter(_tokenExpiry!)) {
      await login();
    }
  }

  Future<List<Map<String, dynamic>>> fetchLocations() async {
    await _checkAndRefreshToken();
    final response = await http.get(
      Uri.parse('$baseUrl/locations'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['locations'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch locations');
    }
  }

  Future<void> createLocation(Map<String, dynamic> location) async {
    await _checkAndRefreshToken();
    final response = await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(location),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create location');
    }
  }
}
