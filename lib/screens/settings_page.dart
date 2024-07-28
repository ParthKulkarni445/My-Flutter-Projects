
import 'package:flutter/material.dart';
import 'package:unite_app/auth_servies.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async{
                  _auth.signOutWithGoogle(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: const RoundedRectangleBorder(
                side: BorderSide(width: 2,color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(30))
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_outlined,color: Colors.white,size: 25,),
                Text(" LOG OUT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            )
          )
        ],
      ),
    );
  }
}