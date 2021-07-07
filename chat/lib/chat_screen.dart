import 'dart:io';
import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';


class ChatScreen extends StatefulWidget {


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> _getUser() async{

    if(_currentUser != null) return _currentUser;

    try{
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = userCredential.user;

      return user;

    } catch (error){
      return null;
    }
  }

  void _sendMessage({String text, File imgfile}) async{

    final User user = await _getUser();

    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Não foi possível fazer o login, tente novamente"),
          backgroundColor: Colors.red,
      ));
    }

    Map<String, dynamic> data = {
      "uid":user.uid,
      "senderName":user.displayName,
      "senderPhotoUrl":user.photoURL,
      "time":Timestamp.now(),
    };

    if(imgfile != null){
      firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance.ref().child(
        user.uid + DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgfile);

      setState(() {
        _isLoading = true;
      });

      firebase_storage.TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;

      setState(() {
        _isLoading = false;
      });
    }
    if(text != null) data['text'] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('messages').orderBy('time').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _currentUser != null ? 'Olá, ${_currentUser.displayName}' : 'Chat app'
        ),
        elevation: 0,
        actions: [
          _currentUser != null ?
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                FirebaseAuth.instance.signOut();
                googleSignIn.signOut();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Você saiu com sucesso."),
                ));
              }
            ) : Container()],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _userStream,
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents = snapshot.data.docs.reversed.toList();

                      return new ListView.builder(
                        reverse: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index){
                          return ChatMessage(documents[index].data(),
                          snapshot.data.docs[index]['uid'] == _currentUser?.uid);
                        },
                      );
                  }
                },
              )
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextCompose(_sendMessage),
        ],
      ),
    );
  }
}
