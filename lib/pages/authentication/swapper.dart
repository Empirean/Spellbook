import 'package:flutter/material.dart';
import 'package:spellbook/pages/authentication/register.dart';
import 'package:spellbook/pages/authentication/login.dart';

class Swapper extends StatefulWidget {
  @override
  _SwapperState createState() => _SwapperState();
}

class _SwapperState extends State<Swapper> {

  bool toggler = true;

  void toggle()
  {
    setState(() {
      toggler = !toggler;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (toggler)
    {
      return Login(toggleView: toggle,);
    }
    else
    {
      return Register(toggleView: toggle,);
    }
  }
}
