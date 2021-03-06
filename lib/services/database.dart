import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kicks_for_nerds/models/posts.dart';
import 'package:uuid/uuid.dart';
import 'auth.dart';

class DataBase {
  final connection = FirebaseDatabase.instance.reference();
  DataBase({uid});

  String uid = '';

  Future<void> updateFlutterArticlesUser(user) async {
    final usersReference = connection.child('users').child(user.uid);
    usersReference.set(
      {
        'uid': user.uid,
        'email': user.email,
        // 'password': user.password,

        // 'username': username,
        //add as many attributes as you want
      },
    );
  }

  Future<void> savePost({title, text, imageUrl}) async {
    String id = Uuid().v1();
    final postReference = connection.child('posts').child(id);
    postReference.set({
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
    });
  }

  List getPost({AsyncSnapshot snapshot}) {
    final postReference = connection.child('posts');
    final List postList = [];
    final Map<dynamic, dynamic> postMap = snapshot.data.snapshot.value;
    postMap.forEach(
      (key, value) {
        postList.add(
          Post(
            imageUrl: value['imageUrl'],
            title: value['title'],
            text: value['text'],
          ),
        );
      },
    );
    return postList;
  }

  Future<int> getPostLength() async {
    final lengthReference = connection.child('posts');
    int postLength =
        await lengthReference.once().then((value) => value.value.length);
    return postLength;
  }

  Future<void> setHandle(String handle) async {
    String user = await AuthService(FirebaseAuth.instance).currentUser();
    //TODO changed handles to handle
    final handleRef = connection.child('handles').child(user);
    handleRef.set({
      'handle': "@$handle",
      'uid': user,
    });
  }

  Future<void> setUserName(String name) async {
    String user = await AuthService(FirebaseAuth.instance).currentUser();
    final handleRef = connection.child('usernames').child(user);
    handleRef.set({
      'username': name,
      'uid': user,
    });
  }
}



// class DataService {}
