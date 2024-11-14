import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000"; // Replace with your server URL
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Signup with JWT token (if the backend supports this)
  Future<http.Response> signup(String fname, String lname, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fname': fname, 'lname': lname, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      // If signup is successful, assume the server returns a JWT token
      final responseData = jsonDecode(response.body);
      final token = responseData['token']; // Adjust based on your API response

      // Store the token securely
      await storage.write(key: 'jwt_token', value: token);
    }

    return response;
  }


  // Signin (store JWT token)
  Future<http.Response> signin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // If signin is successful, store the JWT token
      final responseData = jsonDecode(response.body);
      final token = responseData['token']; // Adjust the key based on the API response

      // Store the token securely
      await storage.write(key: 'jwt_token', value: token);
    }

    return response;
  }

  // Get stored JWT token
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Send authenticated request (example: getting user profile)
  Future<http.Response> getProfile() async {
    final token = await getToken();
    if (token == null) {
      return http.Response('Unauthorized', 401);
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'), // Replace with your protected route
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Send JWT token in the header
      },
    );
    return response;
  }

  // Sign out (clear the JWT token)
  Future<void> signOut() async {
    await storage.delete(key: 'jwt_token');
  }
}
