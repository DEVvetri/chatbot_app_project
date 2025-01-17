import 'package:chatbot_app_project/chatBot_project/chating_module/message/bubblle_container.dart';
import 'package:chatbot_app_project/chatBot_project/chating_module/message/group_chat_screen.dart';
import 'package:chatbot_app_project/firebase/group_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// vetri
class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController messageController = TextEditingController();

  TextEditingController groupNameController = TextEditingController();

  TextEditingController addMemberController = TextEditingController();

  TextEditingController updatedMessageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  GroupMessageReferance groupMessageReferance = GroupMessageReferance();
  bool chatCont = false;
  bool chatDetails = false;
  bool groupInfo = false;
  late String groupName;
  late String groupID;
  late String groupCreatedBy;
  late List listOfMembers;
  late String initialOption;
  Map<dynamic, dynamic> membersPermission = {};
  List<String> options = ['All', 'Admin Only'];
//
  final ScrollController scrollController = ScrollController();

  // void scrollDown() {
  //   scrollController.animateTo(scrollController.position.maxScrollExtent,
  //       duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  // }

  FocusNode myfocus = FocusNode();
  // autoSroll() {
  //   myfocus.addListener(() {
  //     if (myfocus.hasFocus) {
  //       Future.delayed(
  //         const Duration(milliseconds: 300),
  //         () {
  //           scrollDown();
  //         },
  //       );
  //     }
  //   });
  // }

//

  swtichChatCont() {
    setState(() {
      chatCont = !chatCont;
      groupInfo = false;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => scrollToBottom(),
    );
  }

  void scrollToBottom() {
    final double goDown = scrollController.position.extentTotal;
    scrollController.animateTo(
      goDown,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  selectedChat(String id, String name, String email, List membersId,
      Map permission, String optionValue) async {
    setState(() {
      groupID = id;
      groupName = name;
      groupCreatedBy = email;
      listOfMembers = membersId;
      membersPermission.addAll(permission);
      initialOption = optionValue;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () => scrollToBottom(),
    );
  }

  resetModule() {
    setState(() {
      chatCont = false;
    });
  }

  getSeen() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final memberdetails = querySnapshot.docs.first.get('members');

      for (final value in memberdetails.values) {
        if (value['is_unread'] == true) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Message'),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'New group',
                            ),
                            content: SizedBox(
                              width: 350,
                              child: TextFormField(
                                controller: groupNameController,
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
                                  groupNameController.clear();
                                  Get.back();
                                },
                                child: const Text(
                                  'Cancel',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  groupMessageReferance
                                      .createGroup(groupNameController.text,
                                          currentUser!.email.toString())
                                      .whenComplete(() => Get.back());
                                },
                                child: const Text(
                                  'Create',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text("New Group"))
                ];
              },
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              //list chats
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Chats')
                            .where('members_id',
                                arrayContains: currentUser!.email)
                            .snapshots(),
                        builder: (
                          context,
                          snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Something went wrong',
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                            // separatorBuilder: (context, index) {
                            //   return const Divider();
                            // },
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data!.docs[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      groupMessageReferance.messsageMakeAsRead(
                                          currentUser!.email.toString(),
                                          data['group_id']);
                                      if (totalWidth < 850) {
                                        Get.to(() => GroupMessageScreenMob(
                                            groupName: data['group_name'],
                                            groupID: data['group_id'],
                                            groupCreatedBy: data['created_by'],
                                            listOfMembers: data['members_id'],
                                            membersPermission: data['members'],
                                            initialOption:
                                                data['who_can_message']));
                                      } else {
                                        if (chatCont == false) {
                                          swtichChatCont();
                                        }
                                        selectedChat(
                                            data['group_id'],
                                            data['group_name'],
                                            data['created_by'],
                                            data['members_id'],
                                            data['members'],
                                            data['who_can_message']);
                                      }
                                    },
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 25,
                                    ),
                                    title: Text(
                                      data['group_name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: data['members']
                                            [currentUser!.email]['is_unread']
                                        ? const CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.green,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //chat screen
          ],
        ));
  }
}

Widget messageGet(DocumentSnapshot doc, BuildContext context, String groupId) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool iscurrentUser =
      data['sender_email'] == FirebaseAuth.instance.currentUser!.email;

  var alignment = iscurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  // ignore: unused_element
  Future getSeen() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final memberdetails = querySnapshot.docs.first.get('members');

      for (final value in memberdetails.values) {
        if (value['is_unread'] == true) {
          return true;
        }
      }
    }

    return false;
  }

  var addedTime = data['timestamp'] as Timestamp;
  var splitTimeDate = addedTime.toDate().toString();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              iscurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!iscurrentUser)
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('${data["sender_name"]}')
                ],
              ),
            BubbleMessage(
                message: data["message"],
                isMe: iscurrentUser,
                groupid: groupId,
                seens: true),
            Text(splitTimeDate.split(' ')[1])
          ],
        )),
  );
}
