import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/post_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts(int page, int limit) async {
    try {
      // Make the HTTP GET request
      final response = await http
          .get(Uri.parse('$baseUrl?_page=$page&_limit=$limit'))
          .timeout(const Duration(seconds: 10)); // Add a timeout of 10 seconds

      // Handle API errors (non-200 status codes)
      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        // Handle specific HTTP status codes
        switch (response.statusCode) {
          case 400:
            throw Exception('Bad Request: Invalid input');
          case 401:
            throw Exception('Unauthorized: Authentication failed');
          case 404:
            throw Exception('Not Found: The requested resource was not found');
          case 500:
            throw Exception('Internal Server Error: Please try again later');
          default:
            throw Exception(
                'Failed to load posts. Status Code: ${response.statusCode}');
        }
      }
    } on http.ClientException catch (e) {
      // Handle network-related errors (e.g., no internet connection)
      throw Exception('Network Error: ${e.message}');
    } on FormatException catch (e) {
      // Handle JSON parsing errors
      throw Exception('Data Error: Invalid JSON format. ${e.message}');
    } on TimeoutException catch (e) {
      // Handle timeout errors
      throw Exception('Timeout Error: The request took too long. ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors
      throw Exception('Unexpected Error: $e');
    }
  }
}