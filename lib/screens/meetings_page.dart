import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:unite_app/auth_servies.dart';
import 'package:unite_app/utils.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController createRoomWithDesc = TextEditingController();
  TextEditingController joinRoomWithCode = TextEditingController();
  TextEditingController scheduleRoomWithDesc = TextEditingController();
  TextEditingController schedulerDate = TextEditingController();
  TextEditingController schedulerStartTime = TextEditingController();
  TextEditingController schedulerEndTime = TextEditingController();
  late String userName;
  final mgmtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjIxNTQ0NjgsImV4cCI6MTcyMjc1OTI2OCwianRpIjoiYzdjMmYzMTYtYTZjNy00NGVjLWFkMDctZTBjNGNmMTMyZjkwIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJuYmYiOjE3MjIxNTQ0NjgsImFjY2Vzc19rZXkiOiI2Njk3ZjZiOGFkZDEyNjUxYTAyZjhhNjIifQ.Vu6SS9TWqCA5rpCrqMl3k2DED694oni3HIKSIzg0tuk";
  late String roomID;
  late String roomCode;
  bool firstFieldEmpty=false;
  bool secondFieldEmpty=false;
  bool thirdFieldEmpty=false;

  @override
  void initState() {
    super.initState();
    schedulerDate.text=(DateFormat('EEEE, d MMMM yyyy').format(DateTime.now())).toString();
    schedulerStartTime.text=(DateFormat('h:mm a').format(DateTime.now())).toString();
    schedulerEndTime.text=(DateFormat('h:mm a').format(DateTime.now())).toString();
  }

  createRoom(String description) async {
    try{
      final url= Uri.parse("https://api.100ms.live/v2/rooms");
      final res= await http.post(url,
        headers: {
          'Authorization':'Bearer $mgmtToken',
          'Content-Type':'application/json'
        },
        body: jsonEncode({
          'description':"$description"
        })
      );
      final resData = jsonDecode(res.body);

      if(res.statusCode==200&&resData['id']!=null)
      {
        print("Created a room");
        return resData['id'];
      }
      else {print("Couldnt create a room");}
      }catch(e){
        showSnackBar(context, e.toString());
      } 
  }

  createRoomCode(String roomID) async {
    try{
      final url = Uri.parse("https://api.100ms.live/v2/room-codes/room/$roomID/role/host");
      final res= await http.post(url,
          headers: {
            'Authorization':'Bearer $mgmtToken',
            'Content-Type':'application/json'
          },
        );
      final resData=jsonDecode(res.body);

      if(res.statusCode==200&&resData['code']!=null)
      {
        print("Got the room code for host");
        return resData['code'];
      }
      else {print("Couldnt get the room code");}

    }catch(e){
       showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose(){
    scheduleRoomWithDesc.dispose();
    schedulerDate.dispose();
    schedulerEndTime.dispose();
    schedulerStartTime.dispose();
    createRoomWithDesc.dispose();
    joinRoomWithCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              "MeetRooms",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
              ),
            ),
          const SizedBox(height: 5),
          const Divider(color: Colors.grey,thickness: 2,),
          Container(
            width: w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Create MeetRoom",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  "MeetRoom Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: createRoomWithDesc,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    errorText: firstFieldEmpty? "Please enter description":null,
                    contentPadding: const EdgeInsets.all(5),
                    fillColor: Colors.grey[300],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 2,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      )
                    ),
                    onPressed: () async {
                      if(createRoomWithDesc.text=="")
                      {
                        firstFieldEmpty=true;
                        setState(() {});
                      }
                      else
                      {
                        roomID = await createRoom(createRoomWithDesc.text);
                      roomCode = await createRoomCode(roomID);
                      _auth.addMeetRoomHistory(
                        createRoomWithDesc.text, 
                        roomCode,
                        true,
                        context
                        );
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => HMSPrebuilt(
                            roomCode: roomCode,
                            options: HMSPrebuiltOptions(
                              userName: _firebaseAuth.currentUser?.displayName
                            ),
                          )
                        )
                        );
                      }
                
                    }, 
                    child: const Text(
                      "CREATE",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                    )
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          const Divider(color: Colors.grey,thickness: 2,),
          Container(
            width: w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Join MeetRoom",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  "MeetRoom Code",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: joinRoomWithCode,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    errorText: secondFieldEmpty?"Please enter code":null,
                    contentPadding: const EdgeInsets.all(5),
                    fillColor: Colors.grey[300],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 2,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      )
                    ),
                    onPressed: (){
                      if(joinRoomWithCode.text=="")
                      {
                        secondFieldEmpty=true;
                        setState(() {});
                      }
                      else{
                        _auth.addMeetRoomHistory(
                        (createRoomWithDesc.text=="")?"No Description":createRoomWithDesc.text, 
                        joinRoomWithCode.text,
                        false,
                        context
                        );
                       Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => HMSPrebuilt(
                            roomCode: joinRoomWithCode.text,
                            options: HMSPrebuiltOptions(
                              userName: _firebaseAuth.currentUser?.displayName
                            ),
                          )
                        )
                        );
                      }
                    }, 
                    child: const Text(
                      "JOIN",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                    )
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          const Divider(color: Colors.grey,thickness: 2,),
          Container(
            width: w,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Schedule MeetRoom",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  "MeetRoom Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: scheduleRoomWithDesc,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    errorText: thirdFieldEmpty?"Please enter description":null,
                    contentPadding: const EdgeInsets.all(5),
                    fillColor: Colors.grey[300],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "MeetRoom Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: schedulerDate,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.all(5),
                        fillColor: Colors.grey[300],
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), 
                          firstDate: DateTime.now(), 
                          lastDate: DateTime(2100)).then(
                            (value){
                              schedulerDate.text=(DateFormat('EEEE, d MMMM yyyy').format(value!)).toString();
                              setState(() {});
                            }
                          )
                          ;
                      }, 
                      child: Icon(Icons.calendar_month_outlined,color: Colors.white,size: 30,),
                      style: ElevatedButton.styleFrom(  
                        side: BorderSide(width: 1,color: Colors.black),
                        padding: EdgeInsets.all(10),
                        shape: CircleBorder(eccentricity: 0),
                        backgroundColor: Colors.deepPurple
                      )
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Start Time",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: schedulerStartTime,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.all(5),
                        fillColor: Colors.grey[300],
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.dial
                        ).then((value){
                          schedulerStartTime.text=value!.format(context);
                          schedulerEndTime.text=value.format(context);
                          setState(() {});
                        });
                      }, 
                      child: Icon(Icons.more_time_rounded,color: Colors.white,size: 30),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1,color: Colors.black),
                        padding: EdgeInsets.all(10),
                        shape: CircleBorder(eccentricity: 0),
                        backgroundColor: Colors.deepPurple
                      )
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "End Time",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: schedulerEndTime,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.all(5),
                        fillColor: Colors.grey[300],
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.dial,
                        ).then((value){
                          schedulerEndTime.text=value!.format(context);
                          setState(() {});
                        });
                      }, 
                      child: Icon(Icons.more_time_rounded,color: Colors.white,size: 30),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1,color: Colors.black),
                        padding: EdgeInsets.all(10),
                        shape: CircleBorder(eccentricity: 0),
                        backgroundColor: Colors.deepPurple
                      )
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 2,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      )
                    ),
                    onPressed: ()async{
                      if(scheduleRoomWithDesc.text=="")
                      {
                        thirdFieldEmpty=true;
                        setState(() {});
                      }
                      else
                      {
                        context.loaderOverlay.show();
                        DateTime start=DateFormat('h:mm a, EEEE, d MMMM yyyy').parse(schedulerStartTime.text+", "+schedulerDate.text);
                        DateTime end=DateFormat('h:mm a, EEEE, d MMMM yyyy').parse(schedulerEndTime.text+", "+schedulerDate.text);
                        if(start.isAfter(end))
                        {
                          showSnackBar(context, "End time should be after Start Time");
                        }
                        else
                        {
                          roomID = await createRoom(scheduleRoomWithDesc.text);
                          roomCode = await createRoomCode(roomID);
                          _auth.scheduleMeetRoom(
                            scheduleRoomWithDesc.text, 
                            roomCode, 
                            roomID,
                            start, 
                            end, 
                            context
                          );
                        }
                        context.loaderOverlay.hide();
                      }
                    }, 
                    child: const Text(
                      "SCHEDULE",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}