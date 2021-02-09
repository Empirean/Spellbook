import 'package:flutter/material.dart';
import 'package:spellbook/pages/home/spells.dart';
import 'package:spellbook/pages/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:spellbook/services/authenticationservice.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return StreamProvider.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        color: Colors.deepPurple,
        home: Wrapper(),
        routes: {
          "/spells" : (context) => Spells(),
        },
      ),
    );

  }
}


