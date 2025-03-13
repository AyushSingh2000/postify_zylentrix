import 'package:flutter/material.dart';
import 'package:postify/view_model/services/api_service.dart';

import '../model/post_model.dart';

class PostsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  String _errorMessage = '';
  bool _isListView = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get errorMessage => _errorMessage;
  bool get isListView => _isListView;

  Future<void> fetchPosts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPosts = await _apiService.fetchPosts(_page, _limit);
      _posts.addAll(newPosts);
      _isLoading = false;
      _page++;

      if (newPosts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }

    notifyListeners();
  }

  void toggleView() {
    _isListView = !_isListView;
    notifyListeners();
  }
}
