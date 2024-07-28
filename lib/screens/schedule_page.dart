import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unite_app/auth_servies.dart';
import 'package:http/http.dart' as http;
import 'package:unite_app/utils.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final mgmtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjIxNTQ0NjgsImV4cCI6MTcyMjc1OTI2OCwianRpIjoiYzdjMmYzMTYtYTZjNy00NGVjLWFkMDctZTBjNGNmMTMyZjkwIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJuYmYiOjE3MjIxNTQ0NjgsImFjY2Vzc19rZXkiOiI2Njk3ZjZiOGFkZDEyNjUxYTAyZjhhNjIifQ.Vu6SS9TWqCA5rpCrqMl3k2DED694oni3HIKSIzg0tuk";
  
  createRoomCode(String roomID) async {
    try{
      final url = Uri.parse("https://api.100ms.live/v2/room-codes/room/$roomID/role/guest");
      final res= await http.post(url,
          headers: {
            'Authorization':'Bearer $mgmtToken',
            'Content-Type':'application/json'
          },
        );
      final resData=jsonDecode(res.body);

      if(res.statusCode==200&&resData['code']!=null)
      {
        print("Got the room code for guest");
        return resData['code'];
      }
      else {print("Couldnt get the room code");}

    }catch(e){
       showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: BorderDirectional(bottom: BorderSide(width: 2,color: Colors.black),top: BorderSide(width: 2,color: Colors.black))
          ),
          child: const Text(
              "Your Schedule",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
              ),
            ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: AuthService().meetSchedule, 
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              }
          
              return ListView.separated(
                separatorBuilder:(context, index) => const SizedBox(height: 15),
                padding: EdgeInsets.all(10),
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context,index) => ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor:Colors.deepPurple[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.black,
                      width: 2
                    )
                  ),
                  title: Text("${(snapshot.data! as dynamic).docs[index]['roomDesc']}"),
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("MeetRoom Code: ",style: TextStyle(color: Colors.deepPurple[800]),),
                          Text("${(snapshot.data! as dynamic).docs[index]['roomCode']}",style: TextStyle(color: Colors.black),)
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Time: ",style: TextStyle(color: Colors.deepPurple[800]),),
                          Text("${DateFormat('h:mm a, E, d MMMM yyyy').format((snapshot.data! as dynamic).docs[index]['start'].toDate())}",style: TextStyle(color: Colors.black),)
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(width: 2,color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                            ),
                            onPressed: (){
                              _auth.addMeetRoomHistory(
                                (snapshot.data! as dynamic).docs[index]['roomDesc'], 
                                (snapshot.data! as dynamic).docs[index]['roomCode'],
                                true,
                                context
                              );
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => HMSPrebuilt(
                                    roomCode: (snapshot.data! as dynamic).docs[index]['roomCode'],
                                    options: HMSPrebuiltOptions(
                                      userName: _firebaseAuth.currentUser?.displayName
                                    ),
                                    onLeave: ()async{
                                      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('schedule').doc((snapshot.data! as dynamic).docs[index].id).delete();
                                    },
                                  )
                                )
                              );
                            }, 
                            child: Row(
                              children: [
                                Icon(Icons.login_outlined,color: Colors.white,size:25),
                                const Text(
                                  " JOIN",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                              ],
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(width: 2,color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                            ),
                            onPressed: ()async{
                              context.loaderOverlay.show();
                              String roomCode = await createRoomCode((snapshot.data! as dynamic).docs[index]['roomID']);
                              String link="Click on this link to join my meeting (https://parth-videoconf-2222.app.100ms.live/meeting/$roomCode) or simply join by entering the MeetRoom ($roomCode) Code in the Join MeetRoom Section.";
                              await Share.share(link);
                              context.loaderOverlay.hide();
                            }, 
                            child: Row(
                              children: [
                                Icon(Icons.share_rounded,color: Colors.white,size:25),
                                const Text(
                                  " INVITE",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                              ],
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(width: 2,color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              )
                            ),
                            onPressed: ()async{
                              await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('schedule').doc((snapshot.data! as dynamic).docs[index].id).delete();
                            }, 
                            child: Icon(Icons.delete_forever_rounded,color: Colors.white,size: 25)
                          )
                        ],
                      )
                    ],
                  ),
                  subtitleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                )
              );
            }
          ),
        )
      ],
    );
  }
}