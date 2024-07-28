import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body:Column(
        children: [
          Text(
            "Getting You In",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          LinearProgressIndicator(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            minHeight: 5,
          )
        ],
      )
    );
  }
}