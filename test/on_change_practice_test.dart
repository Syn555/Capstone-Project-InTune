import 'package:mockito/annotations.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
// import 'package:mocking/main.dart';
// import 'package:mockito/annotations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
/*
class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements FirebaseUser{}
class MockAuthResults extends Mock implements AuthResult{}
*/
// @GenerateMocks([http.Client])
main() async
{
  //class.status (variable name) for class variables

  final googleSignIn = MockGoogleSignIn();
  final signInAccount = await googleSignIn.signIn();
  final googleAuth = await signInAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken
  );

  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'pls@testthisapp.com',
  );

  final firebaseAuth = MockFirebaseAuth(mockUser: user);
  final result = await firebaseAuth.signInWithCredential(credential);



  test('creates room', () => {


  });


}
