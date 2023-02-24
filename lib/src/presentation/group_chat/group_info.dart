import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom/src/presentation/group_chat/add_members.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName, groupImage;
  const GroupInfo(
      {required this.groupId,
      required this.groupName,
      Key? key,
      required this.groupImage})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Color myGreen = const Color(0xff00C0FF);
  List membersList = [];
  bool isLoading = true;
  bool isSwitched = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      getGroupDetails();
    });
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      //print('mmmm????' + membersList.toString());
      isLoading = false;
      setState(() {});
    });
  }

  bool checkAdmin() {
    bool isAdmin = false;

    membersList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  Future removeMembers(int index) async {
    String uid = membersList[index]['uid'];

    setState(() {
      isLoading = true;
      membersList.removeAt(index);
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      setState(() {
        isLoading = false;
      });
    });
  }

  void showDialogBox(int index) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove This Member'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (checkAdmin()) {
                if (_auth.currentUser!.uid != membersList[index]['uid']) {
                  removeMembers(index);
                  Navigator.pop(context, 'OK');
                }
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });
      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == _auth.currentUser!.uid) {
          membersList.removeAt(i);
        }
      }
      await _firestore.collection('groups').doc(widget.groupId).update({
        "members": membersList,
      });
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const GroupChatHomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                    Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: SizedBox(
                        width: 700,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: size.height / 5,
                            width: size.width / 1.1,
                            child: Column(
                              children: [
                                (widget.groupImage == '' ||
                                        widget.groupImage == null)
                                    ? Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(
                                          Icons.group,
                                          color: Colors.white,
                                          //size: size.width / 20,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 48, // Image radius
                                        backgroundImage: NetworkImage(
                                          'https://excellis.co.in/derick-veliz-admin/public/storage/${widget.groupImage}',
                                        ),
                                      ),
                                // Container(
                                //   height: size.height / 8,
                                //   width: size.height / 8,
                                //   decoration: const BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Colors.grey,
                                //   ),
                                //   child: const Icon(
                                //     Icons.group,
                                //     color: Colors.white,
                                //     //size: size.width / 10,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      widget.groupName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Group . ${membersList.length} Members",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        color: Colors.white,
                        child: SizedBox(
                          width: 700,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: const Icon(Icons.notifications),
                              title: const Text(
                                'Mute Notification',
                                style: TextStyle(
                                    // fontSize: size.width / 18,
                                    //fontWeight: FontWeight.w500,
                                    ),
                              ),
                              trailing: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    // print(isSwitched);
                                  });
                                },
                                activeTrackColor: Colors.grey,
                                activeColor: myGreen,
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(
                      height: 20,
                    ),
                    // Members Name
                    checkAdmin()
                        ? ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddMembersINGroup(
                                  groupChatId: widget.groupId,
                                  name: widget.groupName,
                                  membersList: membersList,
                                ),
                              ),
                            ),
                            leading: const Icon(
                              Icons.add_circle_outline,
                            ),
                            title: const Text(
                              "Add Members",
                              style: TextStyle(
                                  //fontSize: size.width / 22,
                                  //fontWeight: FontWeight.w500,
                                  ),
                            ),
                          )
                        : const SizedBox(),

                    Flexible(
                      child: ListView.builder(
                        itemCount: membersList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                              //onTap: () => showDialogBox(index),
                              leading: const Icon(Icons.account_circle),
                              title: Text(
                                membersList[index]['name'],
                                style: const TextStyle(
                                    //fontSize: size.width / 22,
                                    // fontWeight: FontWeight.w500,
                                    ),
                              ),
                              subtitle: Text(membersList[index]['email']),
                              trailing: TextButton.icon(
                                onPressed: () {
                                  showDialogBox(index);
                                },
                                icon: Text(
                                    membersList[index]['isAdmin']
                                        ? "Admin"
                                        : "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    )),
                                label: Icon(
                                  _auth.currentUser!.uid !=
                                          membersList[index]['uid']
                                      ? Icons.delete
                                      : null,
                                  color: Colors.black54,
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: ListTile(
            onTap: onLeaveGroup,
            leading: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            title: const Text(
              "Leave Group",
              style: TextStyle(
                //fontSize: size.width / 22,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
