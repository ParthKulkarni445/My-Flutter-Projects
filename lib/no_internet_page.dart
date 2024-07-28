import 'dart:io';

import 'package:flutter/material.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {

  bool isConnected = false;

  Future checkConnection() async {
    try{
      final res = await InternetAddress.lookup('google.com');
      if(res.isNotEmpty && res[0].rawAddress.isNotEmpty)
      {
        setState(() {
          isConnected = true;
        });
      }
    }on SocketException catch(_){
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Oops! Lost",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            const Text(
              "Connection",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(child: Icon(Icons.wifi_off_rounded
            ,size: 240,color: Colors.white.withOpacity(0.3),)),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150,50),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 2,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                )
              ),
              onPressed: (){
                checkConnection();
                if(isConnected)
                {
                  Navigator.pop(context);
                }
              }, 
              child: const Text(
                "REFRESH",
                style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 20),
              )
            ),
          ],
        ),
      ),
    );
  }
}