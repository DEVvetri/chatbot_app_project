// ignore_for_file: must_be_immutable, library_private_types_in_public_api, deprecated_member_use

import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/firebase/post_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({
    super.key,
  });

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Commons().blueColor,
        automaticallyImplyLeading: false,
        title: Text('Posts'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAdaptiveDialog(
              context: context, builder: (context) => DialogFb1());
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts') // Replace with your Firestore collection name
            // .where('posted_by', isEqualTo: currentUser.email) // Filter by user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts found.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentItem(
                  id: post['postId'],
                  title: post['postedBy'], // Posted by
                  subtitle: convertTimestampToTimeString(post['time']),
                  comment: post['context'], // Post content
                  onLike: () {
                    // Handle like functionality
                    print('Liked post: ${posts[index].id}');
                  },
                  onMenuOpen: () {
                    // Handle menu open
                    print('Menu opened for post: ${posts[index].id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Utility function to convert timestamp to readable time format
String convertTimestampToTimeString(Timestamp timestamp) {
  DateTime dateTime =
      timestamp.toDate(); // Convert Firestore Timestamp to DateTime
  final DateFormat dateFormat = DateFormat("MMMM dd, yyyy 'at' hh:mm:ss a");
  return dateFormat.format(dateTime);
}

class CommentItem extends StatefulWidget {
  const CommentItem({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.comment,
    this.profileImgUrl,
    required this.onLike,
    required this.onMenuOpen,
  });
  final String id;
  final String title;
  final String subtitle;
  final String comment;
  final String? profileImgUrl;
  final Function onLike;
  final Function onMenuOpen;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final TextEditingController _updateController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;

  final PostHandler _postHandler = PostHandler();

  Future<void> deletePosts() async {
    _postHandler.deletePost(widget.id).whenComplete(() => Get.back());
  }

  Future<void> updatePosts() async {
    _postHandler.UpdatePost(widget.id, _updateController.text)
        .whenComplete(() => Get.back());
  }

  @override
  void initState() {
    super.initState();
    _updateController.text = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              foregroundImage: widget.profileImgUrl != null
                  ? NetworkImage(widget.profileImgUrl!)
                  : null,
              child: Icon(Icons.account_circle),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.comment,
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LikeButton(onPressed: () {}, color: Colors.black87),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem(
                          onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Warning'),
                                  content: const Text(
                                      'Are you sure to delete this Post'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                        onPressed: () {
                                          deletePosts();
                                        },
                                        child: const Text('Yes'))
                                  ],
                                ),
                              ),
                          child: const Text('Delete')),
                      PopupMenuItem(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Update Post Content'),
                                content: SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    controller: _updateController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Cancel',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      updatePosts();
                                    },
                                    child: const Text(
                                      'Update',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Edit')),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.onPressed, this.color});
  final Function onPressed;
  final Color? color;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.color ?? Colors.red,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    );
  }
}

class DialogFb1 extends StatelessWidget {
  DialogFb1({super.key});
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);
  final TextEditingController _usernameController = TextEditingController();
  final PostHandler _postHandler = PostHandler();

  final currentUser = FirebaseAuth.instance.currentUser!;
  Future<void> addposts() async {
    _postHandler
        .addPost(currentUser.email, _usernameController.text)
        .whenComplete(() => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 25,
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/FlutterBricksLogo-Med.png?alt=media&token=7d03fedc-75b8-44d5-a4be-c1878de7ed52"),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _usernameController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Post Your thoughts",
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                    text: "Add",
                    onPressed: () {
                      addposts();
                    }),
                SimpleBtn1(
                  text: "Cancel",
                  onPressed: () {
                    Get.back();
                  },
                  invertedColors: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      super.key});
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}
