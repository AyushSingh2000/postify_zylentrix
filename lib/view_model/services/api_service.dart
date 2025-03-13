import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/post_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts(int page, int limit) async {
    final response =
        await http.get(Uri.parse('$baseUrl?_page=$page&_limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
