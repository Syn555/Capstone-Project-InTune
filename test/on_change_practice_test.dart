import 'package:capstone_project_intune/on_change_practice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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

  TestWidgetsFlutterBinding.ensureInitialized();

  // Set Up Mock Firebase Authentication

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

  final auth = MockFirebaseAuth(mockUser: user);
  final result = await auth.signInWithCredential(credential);

  // Set Up Mock Firestore

  final database = FakeFirebaseFirestore();
  // firestoreInstance.collection(rooms)

 /* await instance.collection('users').add({
    'username': 'Bob',
  });
  final snapshot = await instance.collection('users').get();
  print(snapshot.docs.length); // 1
  print(snapshot.docs.first.get('username')); // 'Bob'
  print(instance.dump()); */

  // Set Up Mock Firebase Storage

  final storage = MockFirebaseStorage();

  // Might need to add stuff


  // Initialize App
  Firebase.initializeApp();


  test ('creates room', () {

    //final database = FakeFirebaseFirestore();

    final onChange = on_change_practice();
    final onChangeState = onChange.createState();
    onChangeState.createRoom();

    expect(onChangeState.roomID, isNotNull);
    //expect(firestoreInstance.collection("rooms").doc(onChangeState.roomID), isNotNull);
  });

  // test ('join call', (){
  //   final onChange = on_change_practice();
  //   final onChangeState = onChange.createState();
  //   onChangeState.joinCall();
  //   expect(onChangeState.controller.text, isNotNull);
  // });

}
