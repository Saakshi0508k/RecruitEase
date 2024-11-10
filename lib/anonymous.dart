import 'package:firebase_auth/firebase_auth.dart';

Future<void> signInAnonymously() async {
  await FirebaseAuth.instance.signInAnonymously();
}
