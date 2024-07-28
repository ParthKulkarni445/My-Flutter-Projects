import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:unite_app/auth_servies.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  
  bool seePassword= true;
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
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Unite",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 60,
                  shadows: [Shadow(color: Colors.black,blurRadius: 50)]
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 2,color: Colors.white)
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 2,color: Colors.white)
                ),
                fillColor: Colors.white.withOpacity(0.3),
                prefixIcon: const Icon(Icons.mail_outline_rounded),
                prefixIconColor: Colors.white
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: seePassword,
              controller: _password,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 2,color: Colors.white)
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 2,color: Colors.white)
                ),
                fillColor: Colors.white.withOpacity(0.3),
                prefixIcon: const Icon(Icons.lock_open_outlined),
                prefixIconColor: Colors.white,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      seePassword = !seePassword;
                    });
                  },
                  icon: Icon(
                    seePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.white,
                  ),
                )
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(w,50),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 2,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                )
              ),
              onPressed: ()async {
                checkConnection();
                if(!isConnected)
                {
                  Navigator.pushNamed(context, '/noconnection');
                }
                bool res= await _auth.signInUserWithEmailAndPassword(_email.text, _password.text, context);
                if(res){
                  Navigator.pushReplacementNamed(context, '/home');
                }
              }, 
              child: const Text(
                "LOGIN",
                style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 20),
              )
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Expanded(child:Divider(thickness: 2)),
                Text(" OR ",style: TextStyle(color: Colors.white,fontSize: 15),),
                Expanded(child:Divider(thickness: 2))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New to Unite?",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                GestureDetector(
                  child: const Text(
                    " Sign Up",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(w,50),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 2,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                )
              ),
              onPressed: () async{
                context.loaderOverlay.show();
                checkConnection();
                if(!isConnected)
                {
                  print("network gela");
                  Navigator.pushNamed(context, '/noconnection');
                }
                bool res = await _auth.signInWithGoogle(context);
                if(res){
                  Navigator.pushReplacementNamed(context, '/home');
                }
                context.loaderOverlay.hide();
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/google_logo.png',height: 35,width: 35,alignment: Alignment.centerLeft),
                  const Text(
                    " GOOGLE",
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                ],
              )
            ),
            

          ],
        ),
      ),
    );
  }
}