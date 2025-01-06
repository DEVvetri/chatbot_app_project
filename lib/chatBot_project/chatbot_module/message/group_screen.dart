import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/bubblle_container.dart';
import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/group_chat_screen.dart';
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
                      child: Card(
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

                            return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final data = snapshot.data!.docs[index];

                                return ListTile(
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
                                  leading: const CircleAvatar(),
                                  title: Text(data['group_name']),
                                  trailing: data['members'][currentUser!.email]
                                          ['is_unread']
                                      ? const CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.green,
                                        )
                                      : null,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //chat screen
            if (totalWidth > 850)
              chatCont
                  //ex
                  ? Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, top: 5.0, bottom: 5.0),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 10,
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                Text(groupName),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                            itemBuilder: (context) {
                                              return <PopupMenuEntry<String>>[
                                                PopupMenuItem(
                                                    onTap: () {
                                                      setState(() {
                                                        groupInfo = true;
                                                      });
                                                    },
                                                    child: const Text('info')),
                                                if (membersPermission[
                                                        currentUser!.email]
                                                    ['is_admin'])
                                                  PopupMenuItem(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              'Add Member'),
                                                          content: SizedBox(
                                                            width: 350,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  addMemberController,
                                                              decoration:
                                                                  InputDecoration(
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            OutlinedButton(
                                                              onPressed: () {
                                                                addMemberController
                                                                    .clear();
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                List<String>
                                                                    userNameGetter =
                                                                    [];
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .where(
                                                                        'email',
                                                                        isEqualTo:
                                                                            addMemberController
                                                                                .text)
                                                                    .get()
                                                                    .then((QuerySnapshot
                                                                        querySnapshot) {
                                                                  if (querySnapshot
                                                                      .docs
                                                                      .isNotEmpty) {
                                                                    userNameGetter.add(
                                                                        querySnapshot
                                                                            .docs
                                                                            .first
                                                                            .get('name'));
                                                                    groupMessageReferance
                                                                        .addMembers(
                                                                            addMemberController
                                                                                .text,
                                                                            groupID,
                                                                            userNameGetter[
                                                                                0])
                                                                        .whenComplete(
                                                                            () {
                                                                      addMemberController
                                                                          .clear();
                                                                      Get.back();
                                                                    });
                                                                  } else {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                        title: const Text(
                                                                            'Error'),
                                                                        content:
                                                                            const Text('User Not Found'),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                              onPressed: () {
                                                                                addMemberController.clear();

                                                                                Get.back();
                                                                              },
                                                                              child: const Text('Ok'))
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
                                              .doc(groupID)
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            // come here
                                            return ListView(
                                              controller: scrollController,
                                              children: snapshot.data!.docs
                                                  .map((e) => InkWell(
                                                      onLongPress: () {
                                                        if (e['sender_email'] ==
                                                            currentUser!
                                                                .email) {
                                                          setState(() {
                                                            updatedMessageController
                                                                    .text =
                                                                e['message'];
                                                          });
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                'Edit Message',
                                                              ),
                                                              content: SizedBox(
                                                                width: 350,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      updatedMessageController,
                                                                  decoration:
                                                                      InputDecoration(
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
                                                                  onPressed:
                                                                      () {
                                                                    updatedMessageController
                                                                        .clear();
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    groupMessageReferance
                                                                        .editMessage(
                                                                            groupID,
                                                                            e
                                                                                .id,
                                                                            updatedMessageController
                                                                                .text)
                                                                        .whenComplete(
                                                                            () {
                                                                      updatedMessageController
                                                                          .clear();
                                                                      Get.back();
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Edit',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {}
                                                      },
                                                      child: messageGet(
                                                          e, context, groupID)))
                                                  .toList(),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            initialOption == 'Admin Only' &&
                                    !membersPermission[currentUser!.email]
                                        ['is_admin']
                                ? const Expanded(
                                    child: Card(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Admins can only send message')
                                      ],
                                    ),
                                  ))
                                : membersPermission[currentUser!.email]
                                        ['is_read_only']
                                    ? const Expanded(
                                        child: Card(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'You are restricted to send message')
                                          ],
                                        ),
                                      ))
                                    : Expanded(
                                        child: Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer
                                                        .withOpacity(0.2),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextFormField(
                                                        controller:
                                                            messageController,
                                                        focusNode: myfocus,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              "Type Message",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    groupMessageReferance
                                                        .sendMessage(
                                                            currentUser!.email
                                                                .toString(),
                                                            messageController
                                                                .text,
                                                            groupID)
                                                        .whenComplete(() {
                                                      messageController.clear();
                                                      scrollToBottom();
                                                      Get.back();
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    )

                  //none chat
                  : Expanded(
                      flex: 2,
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Chats Here",
                              style: Theme.of(context).textTheme.headlineLarge,
                            )
                          ],
                        ),
                      ),
                    ),
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
