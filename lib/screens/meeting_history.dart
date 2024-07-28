import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unite_app/auth_servies.dart';

class MeetingHistory extends StatefulWidget {
  const MeetingHistory({super.key});

  @override
  State<MeetingHistory> createState() => _MeetingHistoryState();
}

class _MeetingHistoryState extends State<MeetingHistory> {
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
              "MeetRoom History",
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
            stream: AuthService().meetHistory, 
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple,));
              }
          
              return ListView.separated(
                separatorBuilder:(context, index) => const SizedBox(height: 15,),
                padding: EdgeInsets.all(10),
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context,index) => ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: ((snapshot.data! as dynamic).docs[index]['role']=='host')?
                  Colors.deepPurple[100]:
                  Colors.white,
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
                      Row(
                        children: [
                          Text("MeetRoom Code: ",style: TextStyle(color: Colors.deepPurple[800]),),
                          Text("${(snapshot.data! as dynamic).docs[index]['roomCode']}",style: TextStyle(color: Colors.black),)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Joined: ",style: TextStyle(color: Colors.deepPurple[800]),),
                          Text("${DateFormat('h:mm a, E, d MMMM yyyy').format((snapshot.data! as dynamic).docs[index]['startTime'].toDate())}",style: TextStyle(color: Colors.black),)
                        ],
                      ),
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