import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/screens/home/search.dart';
import 'package:notes/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:notes/services/database.dart';
import 'package:notes/screens/home/notebox_list.dart';
import 'package:notes/screens/home/profile_pic_picker.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamProvider<DocumentSnapshot?>.value(
      value: DatabaseService(uid: user!.uid).notesSnapshot,
      initialData: null,
      child: HomeChild(),
    );
  }
}

class HomeChild extends StatefulWidget {
  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  bool showGrid = true;
  int crossAxisCount = 2;

  void toggleview() {
    setState(() {
      showGrid = !showGrid;
      if (showGrid) {
        crossAxisCount = 2;
      } else {
        crossAxisCount = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final snapshot = Provider.of<DocumentSnapshot?>(context);

    String profilePic;
    if (snapshot == null) {
      profilePic = '';
    } else {
      profilePic = DatabaseService.getProfilePic(snapshot);
    }

    void showProfileDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 64.0,
                  backgroundColor: Colors.white,
                  backgroundImage: profilePic.isNotEmpty
                      ? NetworkImage(profilePic)
                      : AssetImage('assets/profile.png') as ImageProvider,
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      builder: (context) {
                        return ProfileBottomSheet(context);
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'Change Photo',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF21899C),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
        onPressed: () async {
          var result = await DatabaseService(uid: user!.uid).createNote();
          if (result != null) {
            Navigator.pushNamed(context, '/editor', arguments: result);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFe5ffff),
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await AuthSevice().signOut();
                  print('${user!.uid} signed out');
                },
                icon: Icon(
                  Icons.logout,
                  color: Color(0xff005c6e),
                ),
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
                child: GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(snapshot),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(248, 247, 251, 1),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            print('menu pressed');
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.grey[700],
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'Search your notes',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() => toggleview());
                          },
                          icon: showGrid
                              ? Icon(
                                  Icons.view_agenda_outlined,
                                  color: Colors.grey[700],
                                )
                              : Icon(
                                  Icons.grid_view_outlined,
                                  color: Colors.grey[700],
                                ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        SizedBox(width: 6.0),
                        GestureDetector(
                          onTap: showProfileDialog,
                          child: CircleAvatar(
                            radius: 16.0,
                            backgroundColor: Colors.white,
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : AssetImage('assets/profile.png')
                                    as ImageProvider,
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
              NoteBoxList(crossAxisCount: crossAxisCount),
            ],
          ),
        ),
      ),
    );
  }
}
