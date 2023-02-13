import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cpscom/src/presentation/group_chat/group_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    // log(_auth.currentUser!.displayName.toString());
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          groupName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16.0,
                color: Colors.black,
              ),
        ),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfo(
                        groupName: groupName,
                        groupId: groupChatId,
                      ),
                    ),
                  ),
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        //log(snapshot.data!.docs[index].data().toString());
                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   onPressed: () {},
                            //   icon: const Icon(Icons.photo),
                            // ),
                            hintText: "Type here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 40,
                          color: Colors.blue,
                        ),
                        onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {

    String stringtime = chatMap['time'] == null
        ? DateTime.now().toString()
        : chatMap['time'].toDate().toString();
    DateTime date = DateTime.parse(stringtime);

    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
                chatMap['sendBy'] == _auth.currentUser!.displayName
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: chatMap['sendBy'] == _auth.currentUser!.displayName
                        ? 0
                        : 4,
                    right: chatMap['sendBy'] == _auth.currentUser!.displayName
                        ? 4
                        : 0),
                alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                    width: 180,
                    // padding:const EdgeInsets.only(top:10),
                    alignment: Alignment.center,
                    margin: chatMap['sendBy'] == _auth.currentUser!.displayName
                        ? const EdgeInsets.only(left: 10)
                        : const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 17, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius:
                          chatMap['sendBy'] == _auth.currentUser!.displayName
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))
                              : const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                      gradient:
                          chatMap['sendBy'] == _auth.currentUser!.displayName
                              ? const LinearGradient(colors: [
                                  Color.fromRGBO(0, 192, 255, 1),
                                  Color.fromRGBO(85, 88, 255, 1)
                                ])
                              : const LinearGradient(
                                  colors: [Colors.white, Colors.white]),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          chatMap['sendBy'] == _auth.currentUser!.displayName
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatMap['sendBy'],
                          style: chatMap['sendBy'] ==
                                  _auth.currentUser!.displayName
                              ? const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)
                              : const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                        ),
                        SizedBox(
                          height: size.height / 200,
                        ),
                        Text(
                          chatMap['message'],
                          style: chatMap['sendBy'] ==
                                  _auth.currentUser!.displayName
                              ? const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white)
                              : const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                        ),
                      ],
                    )),
              ),
              Column(
                crossAxisAlignment:
                    chatMap['sendBy'] == _auth.currentUser!.displayName
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.done_all,
                    color: Colors.grey,
                    size: 15,
                  ),
                  Text(
                    DateFormat('hh:mm a').format(date),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
