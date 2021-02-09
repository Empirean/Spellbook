import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spellbook/models/user.dart';
import 'package:spellbook/pages/authentication/swapper.dart';
import 'home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SpellBookUser>(context);
    if (user == null)
    {
      return Swapper();
    }
    else
    {
      return Home();
    }
  }
}

