import 'package:cyclease/audio_player.dart';
import 'package:cyclease/dashboard.dart';
import 'package:cyclease/providers/profile_provider.dart';
import 'package:cyclease/providers/ride_provider.dart';
import 'package:cyclease/providers/user_provider.dart';
import 'package:cyclease/services/MQTTAppState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
 // Import the signup page
void main() {
  runApp(MultiProvider( 
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => RideProvider()),
      ChangeNotifierProvider(create: ((context) => MQTTAppState())), 
    ],
    child: const MyApp()
    )
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        canvasColor: Colors.white,
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.grey),
      ),
      home: const LoginPage(), // Set SignupPage as the initial route
    );
  }
}
