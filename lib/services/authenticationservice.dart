import 'package:firebase_auth/firebase_auth.dart';
import 'package:spellbook/models/user.dart';


class AuthenticationService
{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signOut() async
  {
    try{
      await _auth.signOut();
    }
    catch(e)
    {
      return null;
    }
  }

  Future signUpEmail(String email, String password) async
  {
    try{
      return await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    on FirebaseAuthException catch (error)
    {
      return error.message;
    }
    catch (e)
    {
      return  e.toString();
    }
  }

  Future signInEmail(String email, String password) async
  {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    on FirebaseAuthException catch (e)
    {
      return e.message;
    }
    catch(e)
    {
      return e.toString();
    }
  }

  Stream<SpellBookUser> get user
  {
    return _auth.userChanges().map(( _userFromStream));
  }

  SpellBookUser _userFromStream(User user)
  {
    return user != null ? SpellBookUser(uid: user.uid, ) : null;
  }
  
}