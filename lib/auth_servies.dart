import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unite_app/utils.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get authChanges => _auth.authStateChanges();

  Stream<QuerySnapshot<Map<String, dynamic>>> get meetHistory => _firestore.collection('users').doc(_auth.currentUser!.uid).collection('rooms').orderBy('startTime',descending: true).limit(25).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> get meetSchedule => _firestore.collection('users').doc(_auth.currentUser!.uid).collection('schedule').where('end',isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now())).orderBy('end').snapshots();

  void scheduleMeetRoom(String roomDesc, String roomCode, String roomID, DateTime start, DateTime end, BuildContext context)async{
    try{
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('schedule').add({
        'roomDesc':roomDesc,
        'roomID':roomID,
        'roomCode':roomCode,
        'start':start,
        'end':end,
      });
    }on FirebaseException catch(e){
      showSnackBar(context, e.toString());
    }
  }

  void addMeetRoomHistory(String roomDesc, String roomCode, bool wasHost, BuildContext context) async{
    try{
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('rooms').add({
        'roomDesc':roomDesc,
        'roomCode':roomCode,
        'startTime':DateTime.now(),
        'role': (wasHost)?'host':'guest'
      });
    }on FirebaseException catch(e){
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res=false;
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );

      UserCredential userCred = await _auth.signInWithCredential(cred);

      User? user = userCred.user;
      if(user!=null)
      {
        if(userCred.additionalUserInfo!.isNewUser){
          await _firestore.collection('users').doc(user.uid).set({
            'username':user.displayName,
            'image':user.photoURL,
            'uid':user.uid,
          });
        }
        res=true;
      }
    }on FirebaseAuthException catch(e){
      res=false;
      if(context.mounted)showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> createUserWithEmailAndPassword(String email,String password, BuildContext context) async {
    bool res=false;
    try{
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = cred.user;
      if(user!=null)
      {
        if(cred.additionalUserInfo!.isNewUser){
          await _firestore.collection('users').doc(user.uid).set({
            'username':user.displayName,
            'image':user.photoURL,
            'uid':user.uid,
          });
        }
        res=true;
      }
    }
    on FirebaseAuthException catch(e){
      res=false;
      if(context.mounted)showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> signInUserWithEmailAndPassword(String email,String password, BuildContext context)async{
    bool res=false;
    try{
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = cred.user;
      if(user!=null)
      {
        res=true;
      }
    }
    on FirebaseAuthException catch(e){
      res=false;
      if(context.mounted)showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<void> signOutWithGoogle(BuildContext context) async{
    try{
      await _auth.signOut();
    }on FirebaseAuthException catch(e){
      if(context.mounted)showSnackBar(context, e.message!);
    }
  }
  
}