import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/bubblle_container.dart';
import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/group_info_screen.dart';
import 'package:chatbot_app_project/firebase/group_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMessageScreenMob extends StatefulWidget {
  final String groupName;
  final String groupID;
  final String groupCreatedBy;
  final List listOfMembers;
  final String initialOption;
  final Map<dynamic, dynamic> membersPermission;
  const GroupMessageScreenMob(
      {super.key,
      required this.groupName,
      required this.groupID,
      required this.groupCreatedBy,
      required this.listOfMembers,
      required this.membersPermission,
      required this.initialOption});

  @override
  State<GroupMessageScreenMob> createState() => _GroupMessageScreenMobState();
}

class _GroupMessageScreenMobState extends State<GroupMessageScreenMob> {
  TextEditingController addMemberController = TextEditingController();
  TextEditingController updatedMessageController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;

  GroupMessageReferance groupMessageReferance = GroupMessageReferance();
  ScrollController scrollController = ScrollController();
  final itemKey = GlobalKey();
  FocusNode myfocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // jump();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => scrollToBottom(),
    );
  }

  Future jump() async {
    final context = itemKey.currentContext!;
    await Scrollable.ensureVisible(context, alignment: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Expanded(
          flex: 2,
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Card(
                          elevation: 3,
                          color: Theme.of(context).colorScheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const CircleAvatar(),
                                    const SizedBox(
                                      width: 10,
                                      height: 50,
                                    ),
                                    Text(widget.groupName),
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return <PopupMenuEntry<String>>[
                                    PopupMenuItem(
                                        onTap: () {
                                          Get.to(() => GroupInfoScreenMob(
                                              groupName: widget.groupName,
                                              groupID: widget.groupID,
                                              groupCreatedBy:
                                                  widget.groupCreatedBy,
                                              listOfMembers:
                                                  widget.listOfMembers,
                                              membersPermission:
                                                  widget.membersPermission,
                                              initialOption:
                                                  widget.initialOption));
                                        },
                                        child: const Text('info')),
                                    if (widget.membersPermission[
                                        currentUser!.email]['is_admin'])
                                      PopupMenuItem(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Add Member'),
                                              content: SizedBox(
                                                width: 350,
                                                child: TextFormField(
                                                  controller:
                                                      addMemberController,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    addMemberController.clear();
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    List<String>
                                                        userNameGetter = [];
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .where('email',
                                                            isEqualTo:
                                                                addMemberController
                                                                    .text)
                                                        .get()
                                                        .then((QuerySnapshot
                                                            querySnapshot) {
                                                      if (querySnapshot
                                                          .docs.isNotEmpty) {
                                                        userNameGetter.add(
                                                            querySnapshot
                                                                .docs.first
                                                                .get('name'));
                                                        groupMessageReferance
                                                            .addMembers(
                                                                addMemberController
                                                                    .text,
                                                                widget.groupID,
                                                                userNameGetter[
                                                                    0])
                                                            .whenComplete(() {
                                                          addMemberController
                                                              .clear();
                                                          Get.back();
                                                        });
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                                'Error'),
                                                            content: const Text(
                                                                'User Not Found'),
                                                            actions: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    addMemberController
                                                                        .clear();
      
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ok'))
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Add',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.group_add),
                                            Text(
                                              'Add',
                                            ),
                                          ],
                                        ),
                                      )
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Chats')
                                  .doc(widget.groupID)
                                  .collection('Messages')
                                  .orderBy('timestamp')
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
      // come here                    
                                return ListView(
                                  controller: scrollController,
                                  children: snapshot.data!.docs
                                      .map((e) => InkWell(
                                          onLongPress: () {
                                            if (e['sender_email'] ==
                                                currentUser!.email) {
                                              setState(() {
                                                updatedMessageController.text =
                                                    e['message'];
                                              });
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                    'New group',
                                                  ),
                                                  content: SizedBox(
                                                    width: 350,
                                                    child: TextFormField(
                                                      controller:
                                                          updatedMessageController,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        updatedMessageController
                                                            .clear();
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        groupMessageReferance
                                                            .editMessage(
                                                                widget.groupID,
                                                                e.id,
                                                                updatedMessageController
                                                                    .text)
                                                            .whenComplete(() {
                                                          updatedMessageController
                                                              .clear();
                                                          Get.back();
                                                        });
                                                      },
                                                      child: const Text(
                                                        'edit',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {}
                                          },
                                          child: messageGet(
                                              e, context, widget.groupID)))
                                      .toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                widget.initialOption == 'Admin Only' &&
                        !widget.membersPermission[currentUser!.email]
                            ['is_admin']
                    ? const Expanded(
                        child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Admins can only send message')],
                        ),
                      ))
                    : widget.membersPermission[currentUser!.email]
                            ['is_read_only']
                        ? const Expanded(
                            child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('You are restricted to send message')
                              ],
                            ),
                          ))
                        : Expanded(
                            child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.emoji_emotions),
                                  Expanded(
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                          .withOpacity(0.2),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: messageController,
                                          decoration: const InputDecoration(
                                              hintText: "Type Message",
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton.filled(
                                      onPressed: () {
                                        groupMessageReferance
                                            .sendMessage(
                                                currentUser!.email.toString(),
                                                messageController.text,
                                                widget.groupID)
                                            .whenComplete(() {
                                          scrollToBottom();
                                          messageController.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.send))
                                ],
                              ),
                            ),
                          ))
              ],
            ),
          )),
    );
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}

Widget messageGet(DocumentSnapshot doc, BuildContext context, String groupId) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool iscurrentUser =
      data['sender_email'] == FirebaseAuth.instance.currentUser!.email;
  var alignment = iscurrentUser ? Alignment.centerRight : Alignment.centerLeft;

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
  var splitTimeDate =  addedTime.toDate().toString();
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
                  Text(data['sender_email'].split('@')[0])
                ],
              ),
            BubbleMessage(
                message: data["message"],
                isMe: iscurrentUser,
                groupid: groupId,
                seens: false),
            Text(splitTimeDate.split(' ')[1])
          ],
        )),
  );
}
