// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:chatbot_app_project/firebase/group_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupInfoScreenMob extends StatefulWidget {
  final String groupName;
  final String groupID;
  final String groupCreatedBy;
  final List listOfMembers;
  final String initialOption;
  final Map<dynamic, dynamic> membersPermission;
  const GroupInfoScreenMob(
      {super.key,
      required this.groupName,
      required this.groupID,
      required this.groupCreatedBy,
      required this.listOfMembers,
      required this.membersPermission,
      required this.initialOption});

  @override
  State<GroupInfoScreenMob> createState() => _GroupInfoScreenMobState();
}

class _GroupInfoScreenMobState extends State<GroupInfoScreenMob> {
  TextEditingController addMemberController = TextEditingController();
  late String dropDownValue;

  final currentUser = FirebaseAuth.instance.currentUser;
  GroupMessageReferance groupMessageReferance = GroupMessageReferance();

  List<String> options = ['All', 'Admin Only'];
  @override
  void initState() {
    super.initState();
    dropDownValue = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                            ),
                            Text(
                              widget.groupName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(left: 0, child: BackButton())
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (widget.membersPermission[currentUser!.email]
                        ['is_admin'])
                      Container(
                        width: 150,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3))
                            ]),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Add Member'),
                                  content: SizedBox(
                                    width: 350,
                                    child: TextFormField(
                                      controller: addMemberController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                        List<String> userNameGetter = [];
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .where('email',
                                                isEqualTo:
                                                    addMemberController.text)
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          if (querySnapshot.docs.isNotEmpty) {
                                            userNameGetter.add(querySnapshot
                                                .docs.first
                                                .get('name'));
                                            groupMessageReferance
                                                .addMembers(
                                                    addMemberController.text,
                                                    widget.groupID,
                                                    userNameGetter[0])
                                                .whenComplete(() {
                                              addMemberController.clear();
                                              Get.back();
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Error'),
                                                content: Text('User Not Found'),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        addMemberController
                                                            .clear();

                                                        Get.back();
                                                      },
                                                      child: Text('Ok'))
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
                            icon: const Icon(
                              Icons.group_add_rounded,
                              color: Colors.black,
                            )),
                      ),
                    if (widget.groupCreatedBy == currentUser!.email)
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            borderRadius: BorderRadius.circular(10),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: dropDownValue,
                            items: options
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? v) {
                              setState(
                                () {
                                  dropDownValue = v!;
                                  groupMessageReferance.updateWhoCanMessage(
                                      widget.groupID, dropDownValue);
                                },
                              );
                            }),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(widget.groupID)
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final DocumentSnapshot<Map<String, dynamic>>? document =
                      snapshot.data;
                  final Map<String, dynamic>? documentData = document!.data();
                  if (documentData?['members_id'] == null) {
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No items available'),
                      ],
                    );
                  }

                  final List itemDetailList =
                      (documentData?['members_id'] as List)
                          .map((itemDetail) => itemDetail)
                          .toList();
                  Map details = documentData?['members'];
                  String creterName = documentData?['created_by'];

                  return ListView.separated(
                      itemBuilder: (context, index) {
                        String useremail = itemDetailList[index];

                        String feildValueadmin = 'is_admin';
                        String feildValueread = 'is_read_only';
                        bool isadmin =
                            details[itemDetailList[index]][feildValueadmin];
                        bool isread =
                            details[itemDetailList[index]][feildValueread];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  itemDetailList[index] == currentUser!.email
                                      ? const Text(
                                          "You",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          details[itemDetailList[index]]['name']
                                              .toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                ],
                              ),
                              Row(
                                children: [
                                  details[itemDetailList[index]]
                                          [feildValueadmin]
                                      ? widget.groupCreatedBy ==
                                              itemDetailList[index]
                                          ? const Text(
                                              'Created By',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          : const Text(
                                              'Admin',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                      : const Text('Member',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.normal)),
                                  if (currentUser!.email == creterName &&
                                      itemDetailList[index] != creterName)
                                    PopupMenuButton(
                                      itemBuilder: (context) {
                                        return <PopupMenuEntry<String>>[
                                          !details[itemDetailList[index]]
                                                  [feildValueadmin]
                                              ? PopupMenuItem(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                          'Warning',
                                                        ),
                                                        content: Text(
                                                            'Sure to remove ${itemDetailList[index]}'),
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
                                                            onPressed:
                                                                () async {
                                                              groupMessageReferance
                                                                  .removeMember(
                                                                      widget
                                                                          .groupID,
                                                                      itemDetailList[
                                                                          index])
                                                                  .whenComplete(
                                                                      () {
                                                                Get.back();
                                                              });
                                                            },
                                                            child: const Text(
                                                              'Remove',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .remove_circle_outline),
                                                      Text('Remove'),
                                                    ],
                                                  ))
                                              : PopupMenuItem(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                          'Warning',
                                                        ),
                                                        content: Text(
                                                            'Sure to remove ${itemDetailList[index]}'),
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
                                                            onPressed:
                                                                () async {
                                                              groupMessageReferance
                                                                  .removeMember(
                                                                      widget
                                                                          .groupID,
                                                                      itemDetailList[
                                                                          index])
                                                                  .whenComplete(
                                                                      () {
                                                                Get.back();
                                                              });
                                                            },
                                                            child: const Text(
                                                              'Remove',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.exit_to_app),
                                                      Text('Remove'),
                                                    ],
                                                  )),
                                          if (widget.groupCreatedBy ==
                                              currentUser!.email)
                                            PopupMenuItem(
                                                onTap: () {
                                                  groupMessageReferance
                                                      .updatedMessagePermission(
                                                          widget.groupID,
                                                          useremail,
                                                          feildValueadmin,
                                                          isadmin);
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.verified),
                                                    details[itemDetailList[
                                                                index]]
                                                            [feildValueadmin]
                                                        ? const Text(
                                                            'Depromote')
                                                        : const Text('Promote'),
                                                  ],
                                                )),
                                          if (widget.groupCreatedBy ==
                                              currentUser!.email)
                                            PopupMenuItem(
                                                onTap: () {
                                                  groupMessageReferance
                                                      .updatedMessagePermission(
                                                          widget.groupID,
                                                          useremail,
                                                          feildValueread,
                                                          isread);
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.block),
                                                    details[itemDetailList[
                                                                index]]
                                                            [feildValueread]
                                                        ? const Text('Unblock')
                                                        : const Text(
                                                            'Restrict'),
                                                  ],
                                                )),
                                          if (widget.groupCreatedBy ==
                                              currentUser!.email)
                                            PopupMenuItem(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Warning',
                                                      ),
                                                      content: Text(
                                                          'Sure to Change Owner to ${itemDetailList[index]}'),
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
                                                            groupMessageReferance
                                                                .changeOwnerShip(
                                                                    widget
                                                                        .groupID,
                                                                    'vetrivelmpp004@gmail.com')
                                                                .whenComplete(
                                                                    () {
                                                              Get.back();
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Yes',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons
                                                        .admin_panel_settings_outlined),
                                                    Text('Ownership'),
                                                  ],
                                                ))
                                        ];
                                      },
                                    ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: itemDetailList.length);
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Warning',
                            ),
                            content:
                                Text('Sure to Exit From ${widget.groupName}'),
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
                                  groupMessageReferance
                                      .removeMember(widget.groupID,
                                          currentUser!.email.toString())
                                      .whenComplete(() {
                                    Get.back();
                                  });
                                },
                                child: const Text(
                                  'Exit',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const SizedBox(
                          height: 60,
                          child: Card(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Exit',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.groupCreatedBy == currentUser!.email)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Warning',
                              ),
                              content:
                                  Text('Sure to delete ${widget.groupName}'),
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
                                    groupMessageReferance
                                        .deleteGroup(widget.groupID);

                                    Get.back();
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Delete',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const SizedBox(
                            height: 60,
                            child: Card(
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                  ),
                                  Text(
                                    'Delete',
                                    style: TextStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
