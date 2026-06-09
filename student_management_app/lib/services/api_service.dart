import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/remote_user.dart';

class ApiService {
  static const String _url = 'https://jsonplaceholder.typicode.com/users';

  // Asynchronously fetches external records without stalling the interface
  static Future<List<RemoteUser>> fetchRemoteUsers() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => RemoteUser.fromJson(item)).toList();
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load remote network profiles: $e');
    }
  }
}