import 'package:flutter/material.dart';
import 'package:spellbook/models/user.dart';
import 'package:spellbook/services/database.dart';
import 'package:provider/provider.dart';
import 'package:spellbook/shared/enums.dart';
import 'package:spellbook/shared/loading.dart';
import 'package:spellbook/shared/textdecoration.dart';
import 'package:spellbook/models/spell.dart';

class Spells extends StatefulWidget {
  @override
  _SpellsState createState() => _SpellsState();
}

class _SpellsState extends State<Spells> {
  
  String _spellName = "";
  String _spellDescription = "";
  List<String> _spellTypes = ["Single Target", "Passive", "Area Target", "No Target"];
  String _spellType;
  String _title = "New Spell";

  final _formKey = GlobalKey<FormState>();
  final _spellNameController = TextEditingController();
  final _spellDescriptionController = TextEditingController();

  Map _data = {};
  Spell _spell;
  dataEntryType _entryType;
  bool _isLoading = false;

  @override
  void initState() {
    _spellType = _spellTypes[0];
    _entryType = dataEntryType.add;

    Future.delayed(Duration.zero, (){
      _data = ModalRoute.of(context).settings.arguments;
      if (_data != null) {
        _spell = _data["spell"];
        _entryType = _data["entryMode"];

        if (_entryType == dataEntryType.edit)
        {
          setState(() {
            _title = "Edit Spell";
            _spellName = _spell.spellName;
            _spellNameController.text = _spell.spellName;
            _spellDescription = _spell.spellDescription;
            _spellDescriptionController.text = _spell.spellDescription;
            _spellType = _spell.spellType;
          });
        }
      }
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading)
    {
      return Loading();
    }
    else
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(_title,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  if (_formKey.currentState.validate())
                  {
                    setState(() {
                      final user = Provider.of<SpellBookUser>(context, listen: false);

                      Map<String, dynamic> data = {
                        "SpellName" : _spellName,
                        "SpellType" : _spellType,
                        "SpellDescription" : _spellDescription,
                      };

                      if (_entryType == dataEntryType.add)
                      {

                        _isLoading = true;
                        DatabaseService(path: user.uid).addNewSpell(data);
                        _isLoading = false;
                        setState(() {
                          _spellNameController.clear();
                          _spellDescriptionController.clear();
                          _spellType = _spellTypes[0];

                        });
                      }

                      if (_entryType == dataEntryType.edit)
                      {
                        _isLoading = true;
                        DatabaseService(path: user.uid).updateSpell(data, _spell.id);
                        _isLoading = false;
                        Navigator.pop(context);
                      }


                    });
                  }
                }
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    controller: _spellNameController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                        hintText: "Spell name",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        )
                    ),
                    validator: (val) => val.isEmpty ? "Please provide the spell name" : null,
                    onChanged: (val) {
                      setState(() {
                        _spellName = val;
                      });
                    },
                  ),
                ),
                Card(
                  color: Colors.purple,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        onChanged: (val) {
                          setState(() {
                            _spellType = val;
                          });
                        },
                        dropdownColor: Colors.purple,
                        icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        value: _spellType,
                        isExpanded: true,
                        items: _spellTypes.map((spellType)
                        {
                          return DropdownMenuItem(
                            value: spellType,
                            child: Text(
                              spellType,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: TextFormField(
                    controller: _spellDescriptionController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                        hintText: "Spell Description",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        )
                    ),
                    validator: (val) => val.isEmpty ? "Please provide a description" : null,
                    maxLines: 5,
                    onChanged: (val) {
                      setState(() {
                        _spellDescription = val;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }


  }
}
