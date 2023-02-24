import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateGroup({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });

    String groupId = const Uuid().v1();
    print(_firestore.collection('groups'));
    await _firestore.collection('groups').doc(groupId).set({
      "members": widget.membersList,
      "id": groupId,
      "name": _groupName.text,
      "profile_picture": "",
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
        "profile_picture": "",
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created This Group.",
      "type": "notify",
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const GroupChatHomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Center(
          child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        shadowColor: Colors.black,
        color: Colors.white,
        child: SizedBox(
          width: 700,
          height: 500,
          child: isLoading
              ? Container(
                  height: size.height,
                  width: size.width,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      height: size.height / 14,
                      width: size.width,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: size.height / 14,
                        width: MediaQuery.of(context).size.height * 0.40,
                        child: TextField(
                          controller: _groupName,
                          decoration: InputDecoration(
                            hintText: "Enter Group Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.all(8),
                      textColor: Colors.white,
                      splashColor: Colors.white,
                      elevation: 8.0,
                      // ),
                      onPressed: createGroup,

                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.20,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(0, 192, 255, 1),
                              Color.fromRGBO(85, 88, 255, 1)
                            ])),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Create Group",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //     onPressed: createGroup,
                    //     child: const Text("Create Group"),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blueAccent,
                    //     )),
                  ],
                ),
        ),
      )),
    );
  }
}


//