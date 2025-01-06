
import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/group_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessageReferance {
  final chatsCollecction = FirebaseFirestore.instance.collection('Chats');

  Future<dynamic> createGroup(
      String groupName, String createdByUserEmailId) async {
    DateTime nowTime = DateTime.now();
    String timeForID =
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}.${DateTime.now().microsecond}';
    String customID =
        '${DateTime.now().toString().replaceRange(10, null, "").toString()} ${timeForID}';
    List<String> userNameGetter = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: createdByUserEmailId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userNameGetter.add(querySnapshot.docs.first.get('name'));
      }
    });
    return chatsCollecction.doc(customID).set({
      'group_name': groupName,
      'creatd_at': nowTime,
      'created_by': createdByUserEmailId,
      'members_id': [createdByUserEmailId],
      'members': {
        createdByUserEmailId: {
          'name': userNameGetter[0],
          'is_read_only': false,
          'is_admin': true,
          'is_unread': false
        }
      },
      'who_can_message': 'All',
      'group_id': customID
    });
  }

  Future<dynamic> addMembers(
      String addUserEmail, String documentId, String nameMember) async {
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: documentId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });

    chatsCollecction.doc(documentId).update({
      'members': {
        ...userRole,
        addUserEmail: {
          'name': nameMember,
          'is_read_only': false,
          'is_admin': false,
          'is_unread': false
        },
      },
      'members_id': FieldValue.arrayUnion([addUserEmail])
    });
  }

  Future<dynamic> sendMessage(
      String currentUserEmail, String message, String groupID) async {
    final Timestamp timestamp = Timestamp.now();
    List<String> username = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUserEmail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        username.add(querySnapshot.docs.first.get('name'));
      }
    });
    GroupMessage newMessage = GroupMessage(
        senderEmail: currentUserEmail,
        message: message,
        timestamp: timestamp,
        senderName: username[0]);
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(groupID)
        .collection("Messages")
        .add(newMessage.toMap());
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });

    userRole.forEach((key, value) {
      if (key != currentUserEmail) {
        value['is_unread'] = true;
      }
    });

    chatsCollecction.doc(groupID).update({'members': userRole});
  }

  Future<dynamic> messsageMakeAsRead(String email, String groupID) async {
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });

    userRole.forEach((key, value) {
      if (key == email) {
        value['is_unread'] = false;
      }
    });

    chatsCollecction.doc(groupID).update({'members': userRole});
  }

  Future<dynamic> editMessage(
      String groupID, String messageID, String updatedMessage) async {
    chatsCollecction
        .doc(groupID)
        .collection('Messages')
        .doc(messageID)
        .update({'message': updatedMessage});
  }

  Future<dynamic> removeMember(String groupID, String removeuserEmail) async {
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });
    userRole.remove(removeuserEmail);

    chatsCollecction.doc(groupID).update({
      'members': userRole,
      'members_id': FieldValue.arrayRemove([removeuserEmail])
    });
  }

  Future<dynamic> deleteGroup(String groupID) async {
    chatsCollecction.doc(groupID).delete();
  }

  Future<dynamic> updateWhoCanMessage(String groupID, String value) async {
    chatsCollecction.doc(groupID).update({'who_can_message': value});
  }

  Future<dynamic> updatedMessagePermission(
      String documentID, String email, String feild, bool val) async {
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: documentID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });

    userRole.forEach((key, value) {
      if (key == email) {
        value[feild] = !val;
      }
    });

    chatsCollecction.doc(documentID).update({'members': userRole});
  }

  Future<dynamic> changeOwnerShip(String groupID, String newOwnerEmail) async {
    Map userRole = {};
    await FirebaseFirestore.instance
        .collection('Chats')
        .where('group_id', isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userRole = querySnapshot.docs.first.get('members');
      }
    });

    userRole.forEach((key, value) {
      if (key == newOwnerEmail) {
        value['is_admin'] = true;
      }
    });
    chatsCollecction.doc(groupID).update({'created_by': newOwnerEmail});
  }
}
