import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';

class FollowerListingScreen extends StatefulWidget {
  final String userDocid;
  final String tag;
  const FollowerListingScreen(
      {super.key, required this.userDocid, required this.tag});

  @override
  State<FollowerListingScreen> createState() => _FollowerListingScreenState();
}

class _FollowerListingScreenState extends State<FollowerListingScreen> {
  Future<void> _unfollowUser(String followerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userDocid)
          .update({
        widget.tag: FieldValue.arrayRemove([followerId])
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User unfollowed successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showUnfollowDialog(String followerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unfollow User'),
        content: const Text('Are you sure you want to unfollow this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _unfollowUser(followerId);
            },
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }

  Future<String> _getUserName(String email) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first['name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.tag),
          backgroundColor: Commons().blueColor,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userDocid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data available.'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            List<String> followers = (userData[widget.tag] as List<dynamic>?)
                    ?.whereType<String>()
                    .toList() ??
                [];

            return ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<String>(
                      future: _getUserName(followers[index]),
                      builder: (context, nameSnapshot) {
                        if (nameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading...'),
                          );
                        }
                        return ListTile(
                          title: Text(nameSnapshot.data ?? 'Unknown'),
                          subtitle: Text(followers[index]),
                          trailing: widget.tag == 'following'
                              ? ElevatedButton.icon(
                                  label: Text("Unfollow"),
                                  icon: const Icon(Icons.person_remove,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _showUnfollowDialog(followers[index]),
                                )
                              : ElevatedButton.icon(
                                  label: Text("Remove"),
                                  icon: const Icon(Icons.person_remove,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _showUnfollowDialog(followers[index]),
                                ),
                        );
                      });
                });
          },
        ));
  }
}
