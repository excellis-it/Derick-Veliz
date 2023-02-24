import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/material.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupChatId, name;
  final List membersList;
  const AddMembersINGroup(
      {required this.name,
      required this.membersList,
      required this.groupChatId,
      Key? key})
      : super(key: key);

  @override
  _AddMembersINGroupState createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends State<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    if (_search.text == '' || _search.text == 'null') {
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        await _firestore
            .collection('users')
            .where("email", isEqualTo: _search.text)
            .get()
            .then((value) {
          setState(() {
            if (value.docs.length != 0) {
              userMap = value.docs[0].data();
              isLoading = false;
            } else {
              isLoading = false;
              showToastMessage('No account found with that email address');
            }
          });
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void onAddMembers() async {
    membersList.add(userMap);
    await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": membersList,
    });
    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupChatId)
        .set({"name": widget.name, "id": widget.groupChatId});
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 14,
                width: MediaQuery.of(context).size.height * 0.40,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Email",
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
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : MaterialButton(
                    padding: const EdgeInsets.all(8),
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    elevation: 8.0,
                    // ),
                    onPressed: onSearch,

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
                        padding: EdgeInsets.all(13),
                        child: Text(
                          "Search",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

            // ElevatedButton(
            //     onPressed: onSearch,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blueAccent,
            //     ),
            //     child: const Text("Search")),

            userMap != null
                ? ListTile(
                    onTap: onAddMembers,
                    leading: const Icon(Icons.account_box),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: const Icon(Icons.add_circle_outline),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
