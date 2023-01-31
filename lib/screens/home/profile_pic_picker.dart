import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/services/database.dart';
import 'package:notes/services/storage.dart';
import 'package:provider/provider.dart';

class ProfileBottomSheet extends StatelessWidget {
  BuildContext alertDialogContext;

  ProfileBottomSheet(this.alertDialogContext);

  Future<File?> _getImageFile(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return null;
    }

    File file = File(image.path);
    return file;
  }

  Future _changeProfilePic(
      BuildContext context, User? user, ImageSource source) async {
    File? file = await _getImageFile(source);
    if (file != null) {
      String? url = await StorageService().uploadFile(file, user!.uid);
      if (url != null) {
        await DatabaseService(uid: user.uid).updateProfilePic(url);
        print('profile pic changed');
      }
      Navigator.pop(context);
      Navigator.of(alertDialogContext).pop();
    }
  }

  Future _removeProfilePic(BuildContext context, User? user) async {
    DatabaseService(uid: user!.uid).updateProfilePic('');
    StorageService().deleteFile(user.uid);
    print('profile pic removed');

    Navigator.of(context).pop();
    Navigator.of(alertDialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 16.0, 0.0, 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Profile photo',
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => _removeProfilePic(context, user),
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          onPressed: () async {
                            await _changeProfilePic(
                                context, user, ImageSource.camera);
                          },
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Color(0xFF21899C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      letterSpacing: 0.25,
                    ),
                  )
                ],
              ),
              SizedBox(width: 32.0),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          onPressed: () async {
                            await _changeProfilePic(
                                context, user, ImageSource.gallery);
                          },
                          icon: Icon(
                            Icons.photo,
                            color: Color(0xFF21899C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      letterSpacing: 0.25,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
