import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spellbook/models/spell.dart';

class DatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference ref;
  String path;
  String filter;

  DatabaseService({this.path, this.filter}) {
    ref = _db.collection(path);
  }

  Stream<QuerySnapshot> get spell {
    return ref.snapshots();
  }

  Stream<List<Spell>> get spellList {
    return ref.snapshots().map((e) => _spellFromStream(e, filter));
  }

  List<Spell> _spellFromStream(QuerySnapshot querySnapshot, String filter)
  {
    if (filter == "All")
    {
      return querySnapshot.docs.map((doc) {
        return  Spell(
          spellName: doc["SpellName"] ?? "",
          spellDescription: doc["SpellDescription"] ?? "",
          spellType: doc["SpellType"] ?? "",
          id: doc.id ?? "",
        );
      }).toList();
    }
    else
    {
      return querySnapshot.docs.map((doc) {
        return  Spell(
          spellName: doc["SpellName"] ?? "",
          spellDescription: doc["SpellDescription"] ?? "",
          spellType: doc["SpellType"] ?? "",
          id: doc.id ?? "",
        );
      }).where((element) => element.spellType == filter).toList();
    }
    
    
  }

  Future updateSpell(Map<String, dynamic> data, String id)
  {
    return ref.doc(id).update(data);
  }

  Future deleteSpell(String id)
  {
    return ref.doc(id).delete();
  }

  Future addNewSpell(Map data)
  {
    return ref.add(data);
  }

}