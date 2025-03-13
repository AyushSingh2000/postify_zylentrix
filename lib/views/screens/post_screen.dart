import 'package:flutter/material.dart';
import 'package:postify/views/screens/home_screen.dart';
import 'package:postify/views/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../view_model/post_viewmodel.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/post_item.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to ensure fetchPosts is called after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PostsViewModel>(context, listen: false);
      viewModel.fetchPosts();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final viewModel = Provider.of<PostsViewModel>(context, listen: false);
        viewModel.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostsViewModel>(context);

    return SafeArea(
      child: Scaffold(
        body: _currentIndex == 0
            ? HomeScreen()
            : _currentIndex == 1
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Postify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                viewModel.isListView
                                    ? Icons.toggle_on
                                    : Icons.toggle_off,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => viewModel.toggleView(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: viewModel.errorMessage.isNotEmpty
                            ? Center(
                                child: Text(
                                  viewModel.errorMessage,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : viewModel.isListView
                                ? ListView.builder(
                                    controller: _scrollController,
                                    itemCount: viewModel.posts.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index < viewModel.posts.length) {
                                        final post = viewModel.posts[index];
                                        return PostItem(post: post);
                                      } else if (viewModel.hasMore) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child:
                                                Text('No more posts to load.'),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : GridView.builder(
                                    controller: _scrollController,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemCount: viewModel.posts.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index < viewModel.posts.length) {
                                        final post = viewModel.posts[index];
                                        return SizedBox(
                                          height:
                                              200, // Constrain height of grid items
                                          child: PostItem(post: post),
                                        );
                                      } else if (viewModel.hasMore) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Center(
                                          child: Text('No more posts to load.'),
                                        );
                                      }
                                    },
                                  ),
                      ),
                    ],
                  )
                : ProfileScreen(),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
