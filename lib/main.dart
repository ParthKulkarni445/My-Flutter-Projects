import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:unite_app/auth_servies.dart';
import 'package:unite_app/firebase_options.dart';
import 'package:unite_app/homepage.dart';
import 'package:unite_app/login_screen.dart';
import 'package:unite_app/no_internet_page.dart';
import 'package:unite_app/signup_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 23,
            fontWeight: FontWeight.bold
          )
        ),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/noconnection': (context) => const NoConnectionPage(),
      },
      home: LoaderOverlay(
        child: StreamBuilder(
          stream: AuthService().authChanges,
          builder:(context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasData){
              return const HomePage();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

