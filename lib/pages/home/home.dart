import 'package:flutter/material.dart';
import 'package:spellbook/models/spell.dart';
import 'package:spellbook/models/user.dart';
import 'package:spellbook/pages/home/spellListTile.dart';
import 'package:spellbook/services/authenticationservice.dart';
import 'package:provider/provider.dart';
import 'package:spellbook/services/database.dart';
import 'package:spellbook/shared/loading.dart';
import 'package:spellbook/shared/enums.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _filterValue = "";
  List<String> _filters = ["All", "Single Target", "Passive", "Area Target", "No Target"];

  @override
  void initState() {
    _filterValue = _filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<SpellBookUser>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Spells",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.settings),
            onSelected: (val) {

              if (val == popUpMenuItemsValue.filter){


                AlertDialog alertDialog = AlertDialog(
                  backgroundColor: Colors.deepPurple,
                  title: Text("Filter",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  content: StatefulBuilder(
                    builder:(context, setInnerState) {
                      return DropdownButton(
                        dropdownColor: Colors.deepPurple,
                        value: _filterValue,
                        isExpanded: true,
                        onChanged: (val) {
                          setInnerState(() {
                            setState(() {
                              _filterValue = val;
                            });
                          });
                        },

                        items: _filters.map((filter){
                          return DropdownMenuItem(
                            child: Text(filter,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            value: filter,
                          );
                        }).toList(),
                      );
                    }
                  ),
                );

                showDialog(
                  context: context,
                  builder: (_) => alertDialog,
                );

              }

              if (val == popUpMenuItemsValue.signOut){
                AuthenticationService().signOut();
              }


            },
            color: Colors.deepPurple,
              itemBuilder: (context) => <PopupMenuEntry<popUpMenuItemsValue>>
              [
                PopupMenuItem(
                  child: Text("Filters",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: popUpMenuItemsValue.filter,
                ),
                PopupMenuItem(
                  child: Text("Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: popUpMenuItemsValue.signOut,
                )
              ]
          ),
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseService( path: user.uid, filter: _filterValue).spellList,
        builder: (context, AsyncSnapshot<List<Spell>> snapshot) {
          if (snapshot.hasData)
          {
            if (snapshot.data.length == 0)
            {
              snapshot.data.add(null);
            }

            return Container(
              color: Colors.black,
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return SpellListTile(spell: snapshot.data[index],);
                  }
              ),
            );
          }
          else
          {
            return Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, "/spells");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
