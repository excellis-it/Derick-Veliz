import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom/src/presentation/authenticate/methods.dart';
import 'package:cpscom/src/presentation/group_chat/create_group/add_members.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;
    //print("userID>>>" + _auth.currentUser.toString());

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
        //log("dsfgdf" + groupList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.black45),
        leading: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Image.asset('assets/images/header_icon.png'),
          ),
        ),
        title: Text(
          'CPSCOM',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16.0,
                color: Colors.black,
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Log Out")
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 60),
            color: Colors.white,
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                logOut(context);
              }
            },
          ),
        ],
        toolbarTextStyle: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.black45)
            .bodyText2,
        titleTextStyle: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.black45)
            .headline6,
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                //log("groupList>>" + groupList);
                return Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupChatRoom(
                          groupName: groupList[index]['name'],
                          groupChatId: groupList[index]['id'],
                        ),
                      ),
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Icon(
                        Icons.group,
                        color: Colors.white,
                        //size: size.width / 20,
                      ),
                    ),
                    title: Text(groupList[index]['name']),
                    // subtitle: Text(
                    //   DateFormat('hh:mm a')
                    //       .format(groupList[index]['time'].toDate()),
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: const Color(0xff00C0FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddMembersInGroup()));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Text(''),
            ),
            IconButton(
              icon: const Text(''),
              onPressed: () {},
            ),
            const SizedBox(width: 25),
            IconButton(
              icon: const Text(''),
              onPressed: () {},
            ),
            IconButton(
              icon: const Text(''),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
