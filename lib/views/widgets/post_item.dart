import 'package:flutter/material.dart';

import '../../model/post_model.dart';

class PostItem extends StatefulWidget {
  final Post post;

  PostItem({required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    widget.post.id.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                    print('Heart icon pressed for post ${widget.post.id}');
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0), // Spacer
            Text(
              widget.post.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0), // Spacer
            Expanded(
              child: Text(
                widget.post.body,
                style: TextStyle(
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
