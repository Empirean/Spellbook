import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spellbook/models/spell.dart';
import 'package:spellbook/models/user.dart';
import 'package:provider/provider.dart';
import 'package:spellbook/services/database.dart';
import 'package:spellbook/shared/enums.dart';

class SpellListTile extends StatelessWidget {

  final Spell spell;

  SpellListTile({this.spell});

  @override
  Widget build(BuildContext context) {

    if (spell == null)
    {
      return Card(
        color: Colors.purple,
        child: ListTile(
          title: Text("Empty Library",
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange,
            ),
          ),
        ),
      );
      /*
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/spells");
        },
        child: Card(
          color: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.orange,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
       */
    }

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(context: context, builder: (context) {
          return Container(
            color: Colors.purple,
            child: Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      onPressed: () {
                        final user = Provider.of<SpellBookUser>(context, listen: false);
                        DatabaseService(path: user.uid).deleteSpell(spell.id);
                        Navigator.pop(context);
                      },
                      child: Text("Delete",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.yellow
                        ),
                      ),
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/spells", arguments:{
                          "spell" : spell,
                          "entryMode" : dataEntryType.edit,
                        });
                      },
                      child: Text("Edit",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellow
                        ),
                      ),
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

      },
      child: Card(
        color: Colors.purple,
        child: ListTile(
          title: Text(spell.spellName,
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange
            ),
          ),
          trailing: Text(spell.spellType,
            style: TextStyle(
              color: Colors.yellow
            ),
          ),
          subtitle: Text(spell.spellDescription,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
